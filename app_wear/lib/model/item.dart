abstract class Item<T> {
  const Item();

  String itemId();

  String sortKey();

  static int compare<T extends Item<T>>(Item<T> a, Item<T> b) =>
      a.sortKey().compareTo(b.sortKey());
}

bool intersects<T extends Item>(List<T> a, List<T> b) =>
    a.where((item) => contains(b, item)).isNotEmpty;

bool contains<T extends Item>(List<T> items, T value) =>
    items.where((item) => item.itemId() == value.itemId()).isNotEmpty;
