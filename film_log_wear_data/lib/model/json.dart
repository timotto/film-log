abstract class ToJson {
  Map<String, dynamic> toJson();
}

List<T> typedList<T>(List<dynamic> items) =>
    items.map<T>((item) => item).toList(growable: false);

List<T> allFromJson<T>(
  List<dynamic>? items,
  T Function(Map<String, dynamic>) fromJson,
) =>
    items == null
        ? []
        : items.map((item) => fromJson(item)).toList(growable: false);

List<dynamic> allToJson<T extends ToJson>(List<T> items) =>
    items.map((item) => item.toJson()).toList(growable: false);
