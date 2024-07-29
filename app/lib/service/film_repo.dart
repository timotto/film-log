import 'dart:async';
import 'dart:convert';

import 'package:film_log/model/film_instance.dart';
import 'package:film_log/service/camera_repo.dart';
import 'package:film_log/service/filmstock_repo.dart';
import 'package:film_log/service/filter_repo.dart';
import 'package:film_log/service/lens_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/v4.dart';

import '../model/camera.dart';
import '../model/film_stock.dart';
import '../model/filter.dart';
import '../model/lens.dart';

class FilmRepo {
  final _storageKey = 'film_repo';

  Stream<List<FilmInstance>> itemsStream() => itemsController.stream;

  List<FilmInstance> items() => itemsList;

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
    save();
  }

  Future<void> update(FilmInstance item) async {
    itemsList.removeWhere((i) => i.itemId() == item.itemId());
    itemsList.add(item);
    updateItems([...itemsList]);
    save();
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
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonString);
  }
}
