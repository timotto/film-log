import 'dart:convert';
import 'dart:typed_data';

import 'package:film_log_wear/model/film.dart';
import 'package:film_log_wear/model/photo.dart';
import 'package:film_log_wear/service/camera_repo.dart';
import 'package:film_log_wear/service/filter_repo.dart';
import 'package:film_log_wear/service/lens_repo.dart';
import 'package:film_log_wear/service/wear/decode.dart';
import 'package:film_log_wear/service/wear/encode.dart';
import 'package:film_log_wear_data/model/state.dart';
import 'package:flutter_wear_os_connectivity/flutter_wear_os_connectivity.dart';
import 'package:film_log_wear_data/model/add_photo.dart';

import 'film_repo.dart';

class WearDataService {
  WearDataService._();

  static final _sharedInstance = WearDataService._();

  factory WearDataService() => _sharedInstance;

  final _wearOsConnectivity = FlutterWearOsConnectivity();

  final _filmRepo = FilmRepo();
  final _cameraRepo = CameraRepo();
  final _filterRepo = FilterRepo();
  final _lensRepo = LensRepo();

  WearOsDevice? _device;

  Future<void> setup() async {
    await _wearOsConnectivity.configureWearableAPI();

    await _wearOsConnectivity.registerNewCapability('film_log_client_state');

    final info =
        await _wearOsConnectivity.findCapabilityByName('film_log_server');
    if (info != null) {
      for (var device in info.associatedDevices) {
        await _loadState(device);
      }
    }

    _wearOsConnectivity
        .capabilityChanged(capabilityName: 'film_log_server')
        .listen(_onCapabilityServerChanged);

    _wearOsConnectivity
        .dataChanged(
          pathURI: _stateUri(
            host: '*',
          ),
        )
        .listen(_onServerState);
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
      pathURI: _stateUri(host: device.id),
    );

    if (dataItem == null) {
      print('wear-data::load-state device=$device null data');
      return;
    }

    print('wear-data::load-state device=$device item=$dataItem parsing');
    _parseStateItem(dataItem);
    _device = device;
  }

  void _onServerState(List<DataEvent> events) {
    print('wear-data::on-server-state events.length=${events.length}');
    for (var value in events) {
      _parseStateItem(value.dataItem);
    }
  }

  void _parseStateItem(DataItem dataItem) {
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
  }

  Future<void> sendPhoto({
    required Photo photo,
    required Film film,
  }) async {
    if (_device == null) {
      print('wear-data-service::send-photo - error: no device');
      return;
    }

    final add = AddPhoto(
      filmId: film.id,
      photo: encodePhoto(photo),
    );
    final json = jsonEncode(add);
    await _wearOsConnectivity.sendMessage(
      Uint8List.fromList(json.codeUnits),
      deviceId: _device!.id,
      path: '/film_log_add_photo',
    );
  }
}

Uri _stateUri({required String host}) => Uri(
      scheme: 'wear',
      host: host,
      path: '/film_log_server_state',
    );

Iterable<T> _neverNull<T>(Iterable<T?> items) =>
    items.where((item) => item != null).map((item) => item!);
