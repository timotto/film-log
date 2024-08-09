import 'dart:async';
import 'dart:convert';

import 'package:film_log/model/json.dart';
import 'package:film_log/service/persistence.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/v4.dart';

import '../model/gear.dart';

abstract class GearRepo<T extends Gear> {
  GearRepo({
    required String storageKey,
    required Persistence store,
  })  : _storageKey = storageKey,
        _store = store;

  final String _storageKey;
  final Persistence _store;

  VoidCallback? _listener;

  void addChangeListener(void Function() cb) => _listener = cb;

  Stream<List<T>> itemsStream() => itemsController.stream;

  List<T> items() => itemsList;

  Future<void> add(T item) async {
    itemsList.add(item.withId(const UuidV4().generate()));
    updateItems([...itemsList]);
    await save();
  }

  Future<void> delete(T item) async {
    itemsList.removeWhere((i) => i.itemId() == item.itemId());
    updateItems([...itemsList]);
    await save();
  }

  Future<void> update(T item) async {
    itemsList.removeWhere((i) => i.itemId() == item.itemId());
    itemsList.add(item);
    updateItems([...itemsList]);
    await save();
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

  Future<void> replaceItems(List<T> items) async {
    updateItems(items);
    await save();
  }

  @protected
  T itemFromJson(Map<String, dynamic> json);

  Map<String, dynamic> _toJson() => {'items': ToJson.all(itemsList)};

  void _loadFromJson(Map<String, dynamic> json) {
    final items = FromJson.all(json['items'], itemFromJson);
    updateItems(items);
  }

  Future<void> load() async {
    try {
      print('gear-repo[$_storageKey]::load');
      final jsonString = await _store.get(_storageKey);
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
    await _store.set(_storageKey, jsonString);
    _notify();
  }

  void _notify() {
    if (_listener != null) {
      _listener!();
    }
  }
}
