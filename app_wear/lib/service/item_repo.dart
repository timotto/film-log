import 'dart:async';

import '../model/item.dart';

class ItemRepo<T extends Item> {
  List<T> _value = [];

  final StreamController<List<T>> _controller = StreamController.broadcast();

  List<T> value() => [..._value];

  Stream<List<T>> stream() => _controller.stream;

  void set(List<T> value) {
    _value = [...value];
    _controller.add(_value);
  }

  T? item(String id) =>
      value().where((item) => item.itemId() == id).firstOrNull;

  Stream<T?> itemStream(String id) => stream()
      .map((values) => values.where((item) => item.itemId() == id).firstOrNull);
}
