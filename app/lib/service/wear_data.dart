import 'dart:convert';

import 'package:film_log/service/repos.dart';
import 'package:film_log/service/wear/decode.dart';
import 'package:film_log/service/wear/encode.dart';
import 'package:film_log_wear_data/model/add_photo.dart';
import 'package:film_log_wear_data/model/state.dart';
import 'package:flutter_wear_os_connectivity/flutter_wear_os_connectivity.dart';

import '../model/gear.dart';

class WearDataService {
  WearDataService({required this.repos});

  bool _initialized = false;
  final Repos repos;
  final _wearOsConnectivity = FlutterWearOsConnectivity();

  Future<void> setup() async {
    if (_initialized) return;
    _initialized = true;

    await _wearOsConnectivity.configureWearableAPI();

    await _wearOsConnectivity.registerNewCapability('film_log_server');
    await _wearOsConnectivity.registerNewCapability('film_log_add_photo');

    _wearOsConnectivity
        .messageReceived(
            pathURI: Uri(
          scheme: 'wear',
          path: '/film_log_add_photo',
        ))
        .listen(_onAddPhoto);

    repos.filmRepo.addChangeListener(() => _syncState());

    await _syncState();
  }

  Future<void> _syncState() async {
    await _wearOsConnectivity.syncData(
      path: '/film_log_server_state',
      data: {'data': jsonEncode(_buildState().toJson())},
    );
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

  Future<void> _onAddPhoto(WearOSMessage message) async {
    final add =
        AddPhoto.fromJson(jsonDecode(String.fromCharCodes(message.data)));

    final film = repos.filmRepo
        .items()
        .where((film) => film.id == add.filmId)
        .firstOrNull;

    if (film == null) {
      print('wear-data-service::on-add-photo error: no film with id ${add.filmId}');
      return;
    }

    final photo = decodePhoto(
      add.photo,
      lenses: repos.lensRepo.items(),
      filters: repos.filterRepo.items(),
    );

    final updated = film.update(photos: [...film.photos, photo]);
    await repos.filmRepo.update(updated);
  }
}

bool _intersects<T extends Gear>(List<T> a, List<T> b) =>
    a.where((item) => _contains(b, item)).isNotEmpty;

bool _contains<T extends Gear>(List<T> items, T item) =>
    items.where((value) => value.itemId() == item.itemId()).isNotEmpty;
