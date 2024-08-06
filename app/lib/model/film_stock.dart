import 'filmstock_format.dart';
import 'gear.dart';

class FilmStock implements Gear<FilmStock> {
  final String id;
  final String manufacturer;
  final String product;
  final double iso;
  final FilmStockFormat format;
  final FilmStockType type;

  FilmStock({
    required this.id,
    required this.manufacturer,
    required this.product,
    required this.iso,
    required this.format,
    required this.type,
  });

  FilmStock update({
    String? id,
    String? manufacturer,
    String? product,
    double? iso,
    FilmStockFormat? format,
    FilmStockType? type,
  }) =>
      FilmStock(
        id: id ?? this.id,
        manufacturer: manufacturer ?? this.manufacturer,
        product: product ?? this.product,
        iso: iso ?? this.iso,
        format: format ?? this.format,
        type: type ?? this.type,
      );

  @override
  FilmStock withId(String id) => update(id: id);

  @override
  String itemId() => id;

  @override
  String listItemTitle() => product;

  @override
  String listItemSubtitle() => '$manufacturer $product';

  @override
  String collectionTitle() => product;

  @override
  bool validate() => manufacturer.isNotEmpty && product.isNotEmpty && iso > 0;

  @override
  bool equals(FilmStock other) =>
      id == other.id &&
      manufacturer == other.manufacturer &&
      product == other.product &&
      iso == other.iso &&
      format == other.format &&
      type == other.type;

  factory FilmStock.createNew() => FilmStock(
        id: '',
        manufacturer: '',
        product: '',
        iso: 100,
        format: FilmStockFormat.type120,
        type: FilmStockType.color,
      );

  factory FilmStock.fromJson(Map<String, dynamic> json) => FilmStock(
        id: json['id'],
        manufacturer: json['manufacturer'],
        product: json['product'],
        iso: json['iso'],
        type: FilmStockType.fromJson(json['type']),
        format: FilmStockFormat.fromJson(json['format']),
      );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'manufacturer': manufacturer,
        'product': product,
        'iso': iso,
        'type': type.toJson(),
        'format': format.toJson(),
      };

  @override
  bool operator ==(Object other) {
    if (other is! FilmStock) return false;
    FilmStock o = other;
    return id == o.id &&
        manufacturer == o.manufacturer &&
        product == other.product &&
        iso == other.iso &&
        type == other.type &&
        format == other.format;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      manufacturer.hashCode ^
      product.hashCode ^
      iso.hashCode ^
      type.hashCode ^
      format.hashCode;
}

enum FilmStockType {
  color,
  blackAndWhitePanchromatic,
  blackAndWhiteOrthochromatic,
  blackAndWhiteInfrared;

  dynamic toJson() => name;

  factory FilmStockType.fromJson(dynamic json) =>
      FilmStockType.values.where((v) => v.name == json).first;
}
