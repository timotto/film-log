abstract class Gear<T> {
  T withId(String id);

  String itemId();

  String listItemTitle();

  String listItemSubtitle();

  String collectionTitle();

  bool validate();

  Map<String, dynamic> toJson();
}
