import 'dart:async';

import '../model/item.dart';

class ItemRepo<T extends Item<T>> {
  List<T> _value = [];

  final StreamController<List<T>> _controller = StreamController.broadcast();

  List<T> value() => [..._value];

  Stream<List<T>> stream() => _controller.stream;

  void set(List<T> value) {
    _value = [...value];
    _value.sort(Item.compare);
    _controller.add(_value);
  }

  void update(T item) {
    final value = [..._value].where((v) => v.itemId() != item.itemId());
    set([...value, item]);
  }

  T? item(String id) =>
      value().where((item) => item.itemId() == id).firstOrNull;

  Stream<T?> itemStream(String id) => stream()
      .map((values) => values.where((item) => item.itemId() == id).firstOrNull);
}
