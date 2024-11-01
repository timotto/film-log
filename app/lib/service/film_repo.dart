import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:film_log/model/film_instance.dart';
import 'package:film_log/service/camera_repo.dart';
import 'package:film_log/service/filmstock_repo.dart';
import 'package:film_log/service/filter_repo.dart';
import 'package:film_log/service/lens_repo.dart';
import 'package:film_log/service/persistence.dart';
import 'package:uuid/v4.dart';

import '../model/camera.dart';
import '../model/film_stock.dart';
import '../model/filter.dart';
import '../model/lens.dart';

class FilmRepo {
  FilmRepo({required Persistence store}) : _store = store;

  final Persistence _store;
  final _storageKey = 'film_repo';

  VoidCallback? _listener;

  void addChangeListener(void Function() cb) => _listener = cb;

  Stream<List<FilmInstance>> itemsStream() => itemsController.stream;

  List<FilmInstance> items() => itemsList;

  FilmInstance? item(String id) =>
      items().where((item) => item.id == id).firstOrNull;

  Stream<FilmInstance?> itemStream(String id) => itemsStream()
      .map((items) => items.where((item) => item.id == id).firstOrNull);

  Future<FilmInstance> add(FilmInstance item) async {
    item = item.update(id: const UuidV4().generate());
    itemsList.add(item);
    updateItems([...itemsList]);
    await save();
    return item;
  }

  Future<void> delete(FilmInstance item) async {
    itemsList.removeWhere((i) => i.itemId() == item.itemId());
    updateItems([...itemsList]);
    await save();
  }

  Future<void> update(FilmInstance item) async {
    itemsList.removeWhere((i) => i.itemId() == item.itemId());
    itemsList.add(item);
    updateItems([...itemsList]);
    await save();
  }

  Future<void> updateAll(List<FilmInstance> items, {bool save = true}) async {
    for (var item in items) {
      itemsList.removeWhere((i) => i.itemId() == item.itemId());
      itemsList.add(item);
    }
    updateItems([...itemsList]);

    if (save) {
      await this.save();
    }
  }

  final List<FilmInstance> itemsList = [];

  final StreamController<List<FilmInstance>> itemsController =
      StreamController.broadcast();

  void updateItems(List<FilmInstance> items) {
    itemsList.clear();
    itemsList.addAll(items);
    itemsList.sort(
      (a, b) => a.inserted.compareTo(b.inserted),
    );
    itemsController.add(items);
  }

  Future<void> replaceItems(List<FilmInstance> items) async {
    updateItems(items);
    await save();
  }

  Map<String, dynamic> _toJson() => {
        'items': itemsList.map((item) => item.toJson()).toList(growable: false),
      };

  void _loadFromJson(
    Map<String, dynamic> json, {
    required List<FilmStock> filmstocks,
    required List<Camera> cameras,
    required List<Filter> filters,
    required List<Lens> lenses,
  }) {
    final items = (json['items'] as List<dynamic>)
        .map((j) => FilmInstance.fromJson(
              j,
              filmStock: filmstocks,
              cameras: cameras,
              filters: filters,
              lenses: lenses,
            ))
        .toList();
    updateItems(items);
  }

  Future<void> load({
    required CameraRepo cameraRepo,
    required FilmstockRepo filmstockRepo,
    required FilterRepo filterRepo,
    required LensRepo lensRepo,
  }) async {
    try {
      print('film-repo[$_storageKey]::load');
      final jsonString = await _store.get(_storageKey);
      if (jsonString == null) {
        print('film-repo[$_storageKey]::load - complete no data');
        return;
      }
      final json = jsonDecode(jsonString);

      _loadFromJson(
        json,
        filmstocks: filmstockRepo.items(),
        cameras: cameraRepo.items(),
        filters: filterRepo.items(),
        lenses: lensRepo.items(),
      );
      print(
          'film-repo[$_storageKey]::load - complete ${itemsList.length} items');
    } catch (e) {
      print('film-repo[$_storageKey]::load - failed $e');
    }
  }

  Future<void> save() async {
    final json = _toJson();
    final jsonString = jsonEncode(json);
    await _store.set(_storageKey, jsonString);
    _notify();
  }

  void _notify() {
    if (_listener != null) {
      _listener!();
    }
  }
}
