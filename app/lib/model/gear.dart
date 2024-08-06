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
}
