abstract class Gear<T> {
  const Gear();

  String itemId();
}

bool intersects<T extends Gear>(List<T> a, List<T> b) =>
    a.where((item) => contains(b, item)).isNotEmpty;

bool contains<T extends Gear>(List<T> items, T value) =>
    items.where((item) => item.itemId() == value.itemId()).isNotEmpty;
