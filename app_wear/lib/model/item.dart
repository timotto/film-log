abstract class Item<T> {
  const Item();

  String itemId();
}

bool intersects<T extends Item>(List<T> a, List<T> b) =>
    a.where((item) => contains(b, item)).isNotEmpty;

bool contains<T extends Item>(List<T> items, T value) =>
    items.where((item) => item.itemId() == value.itemId()).isNotEmpty;
