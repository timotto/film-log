import 'package:film_log/model/equals.dart';
import 'package:film_log/model/fstop.dart';

import 'camera.dart';
import 'gear.dart';

class Lens implements Gear<Lens> {
  final String id;
  final String name;
  final String manufacturer;
  final String product;
  final List<Camera> cameras;
  final LensType type;
  final double focalLengthMin;
  final double focalLengthMax;
  final FStopIncrements fStopIncrements;
  final double apertureMin;
  final double apertureMax;

  Lens({
    required this.id,
    required this.name,
    required this.manufacturer,
    required this.product,
    required this.cameras,
    required this.type,
    required this.focalLengthMin,
    required this.focalLengthMax,
    required this.fStopIncrements,
    required this.apertureMin,
    required this.apertureMax,
  });

  Lens update({
    String? id,
    String? name,
    String? manufacturer,
    String? product,
    List<Camera>? cameras,
    LensType? type,
    double? focalLengthMin,
    double? focalLengthMax,
    FStopIncrements? fStopIncrements,
    double? apertureMin,
    double? apertureMax,
  }) =>
      Lens(
        id: id ?? this.id,
        name: name ?? this.name,
        manufacturer: manufacturer ?? this.manufacturer,
        product: product ?? this.product,
        cameras: cameras ?? this.cameras,
        type: type ?? this.type,
        focalLengthMin: focalLengthMin ?? this.focalLengthMin,
        focalLengthMax: focalLengthMax ?? this.focalLengthMax,
        fStopIncrements: fStopIncrements ?? this.fStopIncrements,
        apertureMin: apertureMin ?? this.apertureMin,
        apertureMax: apertureMax ?? this.apertureMax,
      );

  List<double> apertures() {
    final List<double> values;
    switch (fStopIncrements) {
      case FStopIncrements.full:
        values = fStopsWhole();
      case FStopIncrements.half:
        values = fStopsHalf();
      case FStopIncrements.third:
        values = fStopsThird();
    }

    return values
        .where((value) => value >= apertureMin && value <= apertureMax)
        .toList(growable: false);
  }

  @override
  Lens withId(String id) => update(id: id);

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
      focalLengthMin <= focalLengthMax &&
      apertureMin <= apertureMax;

  @override
  bool equals(Lens other) =>
      id == other.id &&
      name == other.name &&
      manufacturer == other.manufacturer &&
      product == other.product &&
      Equals.all(cameras, other.cameras) &&
      type == other.type &&
      focalLengthMin == other.focalLengthMin &&
      focalLengthMax == other.focalLengthMax &&
      fStopIncrements == other.fStopIncrements &&
      apertureMin == other.apertureMin &&
      apertureMax == other.apertureMax;

  factory Lens.createNew() => Lens(
        id: '',
        name: 'New',
        manufacturer: '',
        product: '',
        cameras: [],
        type: LensType.prime,
        focalLengthMin: 90,
        focalLengthMax: 90,
        fStopIncrements: FStopIncrements.full,
        apertureMin: 2.8,
        apertureMax: 22,
      );

  factory Lens.fromJson(
    Map<String, dynamic> json, {
    required List<Camera> cameras,
  }) =>
      Lens(
        id: json['id'],
        name: json['name'],
        manufacturer: json['manufacturer'],
        product: json['product'],
        cameras: cameras
            .where((c) => (json['cameras'] as List<dynamic>)
                .where((id) => c.id == id)
                .isNotEmpty)
            .toList(growable: false),
        type: LensType.fromJson(json['type']),
        focalLengthMin: json['focalLengthMin'],
        focalLengthMax: json['focalLengthMax'],
        fStopIncrements: FStopIncrements.fromJson(json['fStopIncrements']),
        apertureMin: json['apertureMin'],
        apertureMax: json['apertureMax'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'manufacturer': manufacturer,
        'product': product,
        'cameras': cameras.map((c) => c.id).toList(growable: false),
        'type': type.toJson(),
        'focalLengthMin': focalLengthMin,
        'focalLengthMax': focalLengthMax,
        'fStopIncrements': fStopIncrements.toJson(),
        'apertureMin': apertureMin,
        'apertureMax': apertureMax,
      };
}

enum LensType {
  prime,
  zoom;

  dynamic toJson() => name;

  factory LensType.fromJson(dynamic json) =>
      LensType.values.where((v) => v.name == json).first;
}
