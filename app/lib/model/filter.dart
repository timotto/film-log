import 'package:film_log/model/equals.dart';

import 'gear.dart';
import 'lens.dart';

class Filter implements Gear<Filter> {
  final String id;
  final String name;
  final String manufacturer;
  final String product;
  final List<Lens> lenses;

  Filter({
    required this.id,
    required this.name,
    required this.manufacturer,
    required this.product,
    required this.lenses,
  });

  Filter update({
    String? id,
    String? name,
    String? manufacturer,
    String? product,
    List<Lens>? lenses,
  }) =>
      Filter(
        id: id ?? this.id,
        name: name ?? this.name,
        manufacturer: manufacturer ?? this.manufacturer,
        product: product ?? this.product,
        lenses: lenses ?? this.lenses,
      );

  @override
  Filter withId(String id) => update(id: id);

  @override
  String itemId() => id;

  @override
  String listItemTitle() => name;

  @override
  String listItemSubtitle() => '$manufacturer $product';

  @override
  String collectionTitle() => name;

  @override
  bool validate() =>
      name.isNotEmpty && manufacturer.isNotEmpty && product.isNotEmpty;

  @override
  bool equals(Filter other) =>
      id == other.id &&
      name == other.name &&
      manufacturer == other.manufacturer &&
      product == other.product &&
      Equals.all(lenses, other.lenses);

  factory Filter.createNew() => Filter(
        id: '',
        name: 'New',
        manufacturer: '',
        product: '',
        lenses: [],
      );

  factory Filter.fromJson(
    Map<String, dynamic> json, {
    required List<Lens> lenses,
  }) =>
      Filter(
        id: json['id'],
        name: json['name'],
        manufacturer: json['manufacturer'],
        product: json['product'],
        lenses: Gear.fromIdList(json['lenses'], lenses),
      );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'manufacturer': manufacturer,
        'product': product,
        'lenses': Gear.toIdList(lenses),
      };
}
