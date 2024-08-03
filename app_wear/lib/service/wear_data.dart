import 'dart:convert';
import 'dart:typed_data';

import 'package:film_log_wear/model/film.dart';
import 'package:film_log_wear/model/photo.dart';
import 'package:film_log_wear/service/camera_repo.dart';
import 'package:film_log_wear/service/filter_repo.dart';
import 'package:film_log_wear/service/lens_repo.dart';
import 'package:film_log_wear/service/wear/decode.dart';
import 'package:film_log_wear/service/wear/encode.dart';
import 'package:film_log_wear_data/api/capabilities.dart';
import 'package:film_log_wear_data/api/data_paths.dart';
import 'package:film_log_wear_data/model/add_photo.dart';
import 'package:film_log_wear_data/model/pending.dart';
import 'package:film_log_wear_data/model/state.dart';
import 'package:flutter_wear_os_connectivity/flutter_wear_os_connectivity.dart';

import 'film_repo.dart';
import 'wear/fake_state.dart';

class WearDataService {
  WearDataService._();

  static final _sharedInstance = WearDataService._();

  factory WearDataService() => _sharedInstance;

  final _wearOsConnectivity = FlutterWearOsConnectivity();

  final _filmRepo = FilmRepo();
  final _cameraRepo = CameraRepo();
  final _filterRepo = FilterRepo();
  final _lensRepo = LensRepo();

  Pending _pending = const Pending(addPhotos: []);

  Future<void> setup() async {
    await _wearOsConnectivity.configureWearableAPI();
    await _wearOsConnectivity.registerNewCapability(clientCapabilityName);

    final info =
        await _wearOsConnectivity.findCapabilityByName(serverCapabilityName);
    if (info != null) {
      for (var device in info.associatedDevices) {
        await _loadState(device);
      }
    }

    _wearOsConnectivity
        .capabilityChanged(capabilityName: serverCapabilityName)
        .listen(_onCapabilityServerChanged);

    _wearOsConnectivity
        .dataChanged(
          pathURI: syncStateUri(),
        )
        .listen(_onServerState);

    await _restorePending();
  }

  Future<void> _onCapabilityServerChanged(CapabilityInfo info) async {
    print('wear-data::on-capability-server-changed $info');
    for (var device in info.associatedDevices) {
      if (!device.isNearby) continue;

      print('wear-data::on-capability-server-changed device=$device checking');
      await _loadState(device);
    }
  }

  Future<void> _loadState(WearOsDevice device) async {
    final dataItem = await _wearOsConnectivity.findDataItemOnURIPath(
      pathURI: syncStateUri(host: device.id),
    );

    if (dataItem == null) {
      print('wear-data::load-state device=$device null data');
      return;
    }

    print(
        'wear-data::load-state device=${device.id}/${device.name} item=$dataItem parsing');
    await _parseStateItem(dataItem);
  }

  Future<void> _onServerState(List<DataEvent> events) async {
    print('wear-data::on-server-state events.length=${events.length}');
    for (var value in events) {
      await _parseStateItem(value.dataItem);
    }
  }

  Future<void> _parseStateItem(DataItem dataItem) async {
    final String data = dataItem.mapData['data'];
    final state = State.fromJson(jsonDecode(data));

    final cameras =
        _neverNull(state.cameras.map(decodeCamera)).toList(growable: false);

    final lenses = _neverNull(state.lenses.map((item) => decodeLens(
          item,
          cameras: cameras,
        ))).toList(growable: false);

    final filters = _neverNull(state.filters.map((item) => decodeFilter(
          item,
          lenses: lenses,
        ))).toList(growable: false);

    final films = state.films
        .map((item) => decodeFilm(
              item,
              cameras: cameras,
              filters: filters,
              lenses: lenses,
            ))
        .toList(growable: false);

    _filmRepo.set(films);
    _cameraRepo.set(cameras);
    _filterRepo.set(filters);
    _lensRepo.set(lenses);

    print(
        'wear-data-service::parse-state-item: success: films=${films.length} cameras=${cameras.length} filters=${filters.length} lenses=${lenses.length}');

    final pending = _pending.withState(state);
    if (!pending.equals(_pending)) {
      _pending = pending;
      await _sendPending();
    }
  }

  Future<void> sendPhoto({
    required Photo photo,
    required Film film,
  }) async {
    final add = AddPhoto(
      filmId: film.id,
      photo: encodePhoto(photo),
    );
    _pending = _pending.addItem(add);

    await _sendPending();
  }

  Future<void> _sendPending() async {
    await _wearOsConnectivity.syncData(
      path: syncPendingPath,
      data: {'data': jsonEncode(_pending.toJson())},
    );

    print(
        'wear-data-service::send-pending: success: ${_pending.addPhotos.length} items');
  }

  Future<void> _restorePending() async {
    final localDevice = await _wearOsConnectivity.getLocalDevice();

    final dataItems = await _wearOsConnectivity.findDataItemsOnURIPath(
        pathURI: syncPendingUri());
    print(
        'wear-data-service::restore-pending: found ${dataItems.length} items');
    for (var dataItem in dataItems) {
      if (dataItem.pathURI.host != localDevice.id) {
        print(
            'wear-data-service::restore-pending: ignoring foreign item for ${dataItem.pathURI.host}');
        continue;
      }

      final String data = dataItem.mapData['data'];
      final pending = Pending.fromJson(jsonDecode(data));
      print(
          'wear-data-service::restore-pending: restored ${pending.addPhotos.length} items');
      _pending = pending;
    }

    _syncPendingToLocal();
  }

  void _syncPendingToLocal() {
    final byFilm = _pending.addPhotosByFilm;
    for (var filmId in byFilm.keys) {
      var film = _filmRepo.item(filmId);
      if (film == null) {
        print(
            'wear-data-service::sync-pending-to-local: unknown film-id: $filmId');
        continue;
      }

      final photos = byFilm[filmId]!;
      for (var item in photos) {
        final photo = decodePhoto(
          item,
          lenses: _lensRepo.value(),
          filters: _filterRepo.value(),
        );
        film = film!.addPhoto(photo);
      }
      _filmRepo.update(film!);
    }
  }

  void fakeData() {
    DataItem fakeItem = DataItem(
      pathURI: Uri(),
      data: Uint8List(1),
      mapData: {
        'data': jsonEncode(fakeState().toJson()),
      },
    );
    _parseStateItem(fakeItem);
    fakeEditFilm(repo: _filmRepo);
  }
}

Iterable<T> _neverNull<T>(Iterable<T?> items) =>
    items.where((item) => item != null).map((item) => item!);
