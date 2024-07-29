import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/v4.dart';

import '../model/gear.dart';

abstract class GearRepo<T extends Gear> {
  GearRepo({required String storageKey}) : _storageKey = storageKey;

  final String _storageKey;

  Stream<List<T>> itemsStream() => itemsController.stream;

  List<T> items() => itemsList;

  Future<void> add(T item) async {
    print('gear-repo[$_storageKey]::add $item');
    itemsList.add(item.withId(const UuidV4().generate()));
    print('gear-repo[$_storageKey]::add ${item.withId(const UuidV4().generate())}');
    updateItems([...itemsList]);
    save();
  }

  Future<void> delete(T item) async {
    itemsList.removeWhere((i) => i.itemId() == item.itemId());
    updateItems([...itemsList]);
    save();
  }

  Future<void> update(T item) async {
    itemsList.removeWhere((i) => i.itemId() == item.itemId());
    itemsList.add(item);
    updateItems([...itemsList]);
    save();
  }

  @protected
  final List<T> itemsList = [];

  @protected
  final StreamController<List<T>> itemsController =
      StreamController.broadcast();

  @protected
  void updateItems(List<T> items) {
    itemsList.clear();
    itemsList.addAll(items);
    itemsList.sort(
      (a, b) => a.listItemTitle().compareTo(b.listItemTitle()),
    );
    itemsController.add(items);
  }

  @protected
  T itemFromJson(Map<String, dynamic> json);

  Map<String, dynamic> _toJson() => {
        'items': itemsList.map((item) => item.toJson()).toList(growable: false),
      };

  void _loadFromJson(Map<String, dynamic> json) {
    final items =
        (json['items'] as List<dynamic>).map((j) => itemFromJson(j)).toList();
    updateItems(items);
  }

  Future<void> load() async {
    try {
      print('gear-repo[$_storageKey]::load');
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      if (jsonString == null) {
        print('gear-repo[$_storageKey]::load - complete no data');
        return;
      }
      final json = jsonDecode(jsonString);
      _loadFromJson(json);
      print(
          'gear-repo[$_storageKey]::load - complete ${itemsList.length} items');
    } catch (e) {
      print('gear-repo[$_storageKey]::load - failed $e');
    }
  }

  Future<void> save() async {
    final json = _toJson();
    final jsonString = jsonEncode(json);
    print('gear-repo[$_storageKey]::save $jsonString');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonString);
  }
}