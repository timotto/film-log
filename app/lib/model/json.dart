abstract class ToJson {
  Map<String, dynamic> toJson();

  static List<dynamic> all<T extends ToJson>(List<T> items) =>
      items.map((item) => item.toJson()).toList(growable: false);
}

abstract class FromJson {
  static T? orNull<T>(
    Map<String, dynamic>? json,
    T Function(Map<String, dynamic>) fromJson,
  ) =>
      json == null ? null : fromJson(json);

  static List<T> all<T>(
          List<dynamic>? json, T Function(Map<String, dynamic>) fromJson) =>
      json == null
          ? []
          : json.map((item) => fromJson(item)).toList(growable: false);
}
