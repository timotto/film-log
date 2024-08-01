import 'dart:async';

class ItemRepo<T> {
  List<T> _value = [];

  final StreamController<List<T>> _controller = StreamController.broadcast();

  List<T> value() => [..._value];

  Stream<List<T>> stream() => _controller.stream;

  void set(List<T> value) {
    _value = [...value];
    _controller.add(_value);
  }
}