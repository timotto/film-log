import 'package:film_log/model/equals.dart';

import 'json.dart';

abstract class Gear<T> implements ToJson, Equals<T> {
  T withId(String id);

  String itemId();

  String listItemTitle();

  String listItemSubtitle();

  String collectionTitle();

  bool validate();

  @override
  Map<String, dynamic> toJson();

  static T? byId<T extends Gear>(String? id, List<T> items) => id == null
      ? null
      : items.where((item) => item.itemId() == id).firstOrNull;

  static List<T> fromIdList<T extends Gear>(
          List<dynamic>? ids, List<T> items) =>
      ids == null
          ? []
          : items
              .where((item) => ids.contains(item.itemId()))
              .toList(growable: false);

  static List<String> toIdList<T extends Gear>(List<T> items) =>
      items.map((item) => item.itemId()).toList(growable: false);
}
