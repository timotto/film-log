import 'json.dart';

abstract class Gear<T> extends ToJson {
  T withId(String id);

  String itemId();

  String listItemTitle();

  String listItemSubtitle();

  String collectionTitle();

  bool validate();

  @override
  Map<String, dynamic> toJson();
}
