import 'package:film_log/model/shutter_speed.dart' as s;

import 'filmstock_format.dart';
import 'gear.dart';

class Camera implements Gear<Camera> {
  final String id;
  final String name;
  final String manufacturer;
  final String product;
  final double fastestShutterSpeed;
  final double slowestShutterSpeed;
  final FilmStockFormat filmstockFormat;
  final int? defaultFramesPerFilm;

  Camera({
    required this.id,
    required this.name,
    required this.manufacturer,
    required this.product,
    required this.fastestShutterSpeed,
    required this.slowestShutterSpeed,
    required this.filmstockFormat,
    required this.defaultFramesPerFilm,
  });

  List<double> shutterSpeeds() => s
      .shutterSpeeds()
      .where((value) =>
          value >= fastestShutterSpeed && value <= slowestShutterSpeed)
      .toList(growable: false);

  @override
  Camera withId(String id) => update(id: id);

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
      name.isNotEmpty &&
      manufacturer.isNotEmpty &&
      product.isNotEmpty &&
      fastestShutterSpeed != 0 &&
      slowestShutterSpeed != 0 &&
      fastestShutterSpeed <= slowestShutterSpeed;

  @override
  bool equals(Camera other) =>
      id == other.id &&
      name == other.name &&
      manufacturer == other.manufacturer &&
      product == other.product &&
      fastestShutterSpeed == other.fastestShutterSpeed &&
      slowestShutterSpeed == other.slowestShutterSpeed &&
      filmstockFormat == other.filmstockFormat &&
      defaultFramesPerFilm == other.defaultFramesPerFilm;

  Camera update({
    String? id,
    String? name,
    String? manufacturer,
    String? product,
    double? fastestShutterSpeed,
    double? slowestShutterSpeed,
    FilmStockFormat? filmstockFormat,
    int? defaultFramesPerFilm,
  }) =>
      Camera(
        id: id ?? this.id,
        name: name ?? this.name,
        manufacturer: manufacturer ?? this.manufacturer,
        product: product ?? this.product,
        fastestShutterSpeed: fastestShutterSpeed ?? this.fastestShutterSpeed,
        slowestShutterSpeed: slowestShutterSpeed ?? this.slowestShutterSpeed,
        filmstockFormat: filmstockFormat ?? this.filmstockFormat,
        defaultFramesPerFilm: defaultFramesPerFilm ?? this.defaultFramesPerFilm,
      );

  factory Camera.createNew() => Camera(
        id: '',
        name: 'New',
        manufacturer: '',
        product: '',
        fastestShutterSpeed: 1 / 1000,
        slowestShutterSpeed: 1,
        filmstockFormat: FilmStockFormat.type120,
        defaultFramesPerFilm: null,
      );

  factory Camera.fromJson(Map<String, dynamic> json) => Camera(
        id: json['id'],
        name: json['name'],
        manufacturer: json['manufacturer'],
        product: json['product'],
        fastestShutterSpeed: json['fastestShutterSpeed'],
        slowestShutterSpeed: json['slowestShutterSpeed'],
        filmstockFormat: FilmStockFormat.fromJson(json['filmstockFormat']),
        defaultFramesPerFilm: json['defaultFramesPerFilm'],
      );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'manufacturer': manufacturer,
        'product': product,
        'fastestShutterSpeed': fastestShutterSpeed,
        'slowestShutterSpeed': slowestShutterSpeed,
        'filmstockFormat': filmstockFormat.toJson(),
        'defaultFramesPerFilm': defaultFramesPerFilm,
      };
}
