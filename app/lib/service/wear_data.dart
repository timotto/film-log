import 'dart:convert';

import 'package:film_log/model/film_instance.dart';
import 'package:film_log/service/repos.dart';
import 'package:film_log/service/wear/decode.dart';
import 'package:film_log/service/wear/encode.dart';
import 'package:film_log_wear_data/api/capabilities.dart';
import 'package:film_log_wear_data/api/data_paths.dart';
import 'package:film_log_wear_data/model/pending.dart';
import 'package:film_log_wear_data/model/state.dart';
import 'package:flutter_wear_os_connectivity/flutter_wear_os_connectivity.dart';
import 'package:logging/logging.dart';

import '../model/gear.dart';

class WearDataService {
  WearDataService({required this.repos});

  final _log = Logger('wear-data-service');

  bool _initialized = false;
  final Repos repos;
  final _wearOsConnectivity = FlutterWearOsConnectivity();

  Future<void> setup() async {
    if (_initialized) return;
    _initialized = true;

    await _wearOsConnectivity.configureWearableAPI();
    await _wearOsConnectivity.registerNewCapability(serverCapabilityName);

    _wearOsConnectivity
        .dataChanged(
          pathURI: Uri(
            scheme: 'wear',
            host: '*',
            path: syncPendingPath,
          ),
        )
        .listen(_onClientPending)
        .onError((err) => _log.info('cannot listen for pending changes', err));

    await _syncState();
    await _findPending();
    repos.addChangeListener(_syncState);
  }

  Future<void> _syncState() async {
    final state = _buildState();
    await _wearOsConnectivity.syncData(
      path: syncStatePath,
      data: {'data': jsonEncode(state.toJson())},
    );

    _log.finer(
        'wear-data-service::sync-state: sent: films=${state.films.length} cameras=${state.cameras.length}');
  }

  State _buildState() {
    final films = repos.filmRepo
        .items()
        .where((item) => !item.archive)
        .toList(growable: false);

    final cameras = films
        .where((item) => item.camera != null)
        .map((item) => item.camera!)
        .toList(growable: false);

    final lenses = repos.lensRepo
        .items()
        .where((lens) => _intersects(lens.cameras, cameras))
        .toList(growable: false);

    final filters = repos.filterRepo
        .items()
        .where((filter) => _intersects(filter.lenses, lenses))
        .toList(growable: false);

    return State(
      films: films
          .map((item) => encodeFilm(item, lenses: lenses))
          .toList(growable: false),
      filters:
          filters.map((item) => encodeFilter(item)).toList(growable: false),
      lenses: lenses.map((item) => encodeLens(item)).toList(growable: false),
      cameras:
          cameras.map((item) => encodeCamera(item)).toList(growable: false),
    );
  }

  Future<void> _findPending() async {
    final info =
        await _wearOsConnectivity.findCapabilityByName(clientCapabilityName);
    if (info == null) {
      _log.fine('wear-data-service::find-pending: null info');
      return;
    }

    _log.finer(
        'wear-data-service::find-pending: ${info.associatedDevices.length} devices');

    for (var device in info.associatedDevices) {
      await _loadPending(device);
    }
  }

  Future<void> _loadPending(WearOsDevice device) async {
    final dataItem = await _wearOsConnectivity.findDataItemOnURIPath(
      pathURI: syncPendingUri(host: device.id),
    );

    if (dataItem == null) {
      _log.fine('wear-data-service::load-pending device=$device null data');
      return;
    }

    _log.finer(
        'wear-data-service::load-pending device=${device.id}/${device.name} item=$dataItem parsing');
    await _parsePendingItems([dataItem]);
  }

  Future<void> _parsePendingItems(List<DataItem> dataItems) async {
    _log.finer(
        'wear-data-service::parse-pending-items: received ${dataItems.length} items');

    final List<FilmInstance> updates = [];

    for (var dataItem in dataItems) {
      final data = dataItem.mapData['data'];
      if (data == null) {
        _log.fine('wear-data-service::parse-pending-items: null data');
        continue;
      }

      final pending = Pending.fromJson(jsonDecode(data));
      if (pending.isEmpty) {
        _log.finer('wear-data-service::parse-pending-items: no changes');
        continue;
      }

      final byFilm = pending.addPhotosByFilm;
      for (var filmId in byFilm.keys) {
        var film = repos.filmRepo
            .items()
            .where((film) => film.id == filmId)
            .firstOrNull;

        if (film == null) {
          _log.info(
              'wear-data-service::parse-pending-items: error: invalid film-id: $filmId');
          continue;
        }

        final photos = byFilm[filmId]!;
        for (var p in photos) {
          final photo = decodePhoto(
            p,
            lenses: repos.lensRepo.items(),
            filters: repos.filterRepo.items(),
          );

          film = film!.addPhoto(photo);
        }

        updates.add(film!);
      }
    }

    if (updates.isEmpty) {
      _log.finer('wear-data-service::parse-pending-items: no updates');
      return;
    }

    await repos.filmRepo.updateAll(updates);
    _log.finer(
        'wear-data-service::parse-pending-items: success: ${updates.length} updates');
  }

  Future<void> _onClientPending(List<DataEvent> events) async {
    _log.finer(
        'wear-data-service::on-client-pending: received ${events.length} events');

    final List<DataItem> dataItems = [];
    for (var event in events) {
      if (event.type != DataEventType.changed) {
        _log.fine(
            'wear-data-service::on-client-pending: bad event type: ${event.type}');
        continue;
      }

      dataItems.add(event.dataItem);
    }

    await _parsePendingItems(dataItems);
  }
}

bool _intersects<T extends Gear>(List<T> a, List<T> b) =>
    a.where((item) => _contains(b, item)).isNotEmpty;

bool _contains<T extends Gear>(List<T> items, T item) =>
    items.where((value) => value.itemId() == item.itemId()).isNotEmpty;
