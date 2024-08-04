import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:film_log_wear/model/film.dart';
import 'package:film_log_wear/model/photo.dart';
import 'package:film_log_wear/service/camera_repo.dart';
import 'package:film_log_wear/service/filter_repo.dart';
import 'package:film_log_wear/service/lens_repo.dart';
import 'package:film_log_wear/service/sync.dart';
import 'package:film_log_wear_data/api/capabilities.dart';
import 'package:film_log_wear_data/api/data_paths.dart';
import 'package:film_log_wear_data/model/pending.dart';
import 'package:film_log_wear_data/model/state.dart';
import 'package:flutter_wear_os_connectivity/flutter_wear_os_connectivity.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'film_repo.dart';
import 'wear/fake_state.dart';

final _log = Logger('wear-data-service');

class WearDataService {
  WearDataService._() {
    _sync = SyncService(
      filmRepo: _filmRepo,
      cameraRepo: _cameraRepo,
      filterRepo: _filterRepo,
      lensRepo: _lensRepo,
      publishPending: (value) => _sendPending(value),
    );
  }

  static final _sharedInstance = WearDataService._();

  factory WearDataService() => _sharedInstance;

  final _wearOsConnectivity = FlutterWearOsConnectivity();

  final _filmRepo = FilmRepo();
  final _cameraRepo = CameraRepo();
  final _filterRepo = FilterRepo();
  final _lensRepo = LensRepo();
  late SyncService _sync;

  late final SharedPreferences _prefs;

  bool _initialized = false;
  final _initializedController = StreamController<bool>.broadcast();

  bool initialized() => _initialized;

  Stream<bool> initializedStream() => _initializedController.stream;

  Future<void> setup() async {
    _prefs = await SharedPreferences.getInstance();

    try {
      await _wearOsConnectivity.configureWearableAPI();
      await _wearOsConnectivity.registerNewCapability(clientCapabilityName);

      _wearOsConnectivity
          .dataChanged(
            pathURI: syncStateUri(),
          )
          .listen(_onServerState);

      await _loadStoredState();
      await _discoverState();
      await _restorePending();
    } finally {
      _initialized = true;
      _initializedController.add(true);
    }
  }

  Future<void> _discoverState() async {
    final info =
        await _wearOsConnectivity.findCapabilityByName(serverCapabilityName);
    if (info != null) {
      for (var device in info.associatedDevices) {
        await _loadState(device);
      }
    }
  }

  Future<void> _loadState(WearOsDevice device) async {
    final dataItem = await _wearOsConnectivity.findDataItemOnURIPath(
      pathURI: syncStateUri(host: device.id),
    );

    if (dataItem == null) {
      _log.fine('wear-data::load-state device=$device null data');
      return;
    }

    _log.finer('wear-data::load-state device=${device.id}/${device.name}');
    await _parseStateDataItem(dataItem);
  }

  Future<void> _onServerState(List<DataEvent> events) async {
    _log.finer('wear-data::on-server-state events.length=${events.length}');
    for (var value in events) {
      await _parseStateDataItem(value.dataItem);
    }
  }

  Future<void> _parseStateDataItem(DataItem dataItem) async {
    final String data = dataItem.mapData['data'];
    final state = State.fromJson(jsonDecode(data));

    await _readStateInfo(state);
    await _writeStoredState(state);
  }

  Future<void> _readStateInfo(State state) async {
    await _sync.importState(state);
  }

  Future<void> sendPhoto({
    required Photo photo,
    required Film film,
  }) async {
    await _sync.addPhoto(photo: photo, filmId: film.id);
  }

  Future<void> _sendPending(Pending pending) async {
    await _wearOsConnectivity.syncData(
      path: syncPendingPath,
      data: {'data': jsonEncode(pending.toJson())},
    );

    _log.finer(
        'wear-data-service::send-pending: success: ${pending.addPhotos.length} items');
  }

  Future<void> _restorePending() async {
    final localDevice = await _wearOsConnectivity.getLocalDevice();

    final dataItems = await _wearOsConnectivity.findDataItemsOnURIPath(
        pathURI: syncPendingUri());
    _log.finer(
        'wear-data-service::restore-pending: found ${dataItems.length} items');
    for (var dataItem in dataItems) {
      if (dataItem.pathURI.host != localDevice.id) {
        _log.fine(
            'wear-data-service::restore-pending: ignoring foreign item for ${dataItem.pathURI.host}');
        continue;
      }

      final String data = dataItem.mapData['data'];
      final pending = Pending.fromJson(jsonDecode(data));
      _log.finer(
          'wear-data-service::restore-pending: restored ${pending.addPhotos.length} items');
      _sync.pending = pending;
    }
  }

  Future<bool> openPhoneApp() async {
    final info =
        await _wearOsConnectivity.findCapabilityByName(serverCapabilityName);
    if (info == null) {
      print('wear-data-service::open-phone-app: error: null info');
      return false;
    }

    for (var device in info.associatedDevices) {
      if (!device.isNearby) continue;

      await _wearOsConnectivity.startRemoteActivity(
        url: "filmLog://MainActivity",
        deviceId: device.id,
      );
    }

    return true;
  }

  Future<void> _loadStoredState() async {
    final json = _prefs.getString('state');
    if (json == null) return;
    final state = State.fromJson(jsonDecode(json));
    await _readStateInfo(state);
  }

  Future<void> _writeStoredState(State state) async {
    final json = jsonEncode(state.toJson());
    await _prefs.setString('state', json);
  }

  void fakeData() {
    DataItem fakeItem = DataItem(
      pathURI: Uri(),
      data: Uint8List(1),
      mapData: {
        'data': jsonEncode(fakeState().toJson()),
      },
    );
    _parseStateDataItem(fakeItem);
    fakeEditFilm(repo: _filmRepo);
  }
}
