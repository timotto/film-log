import 'package:film_log_wear/model/util.dart';

import 'item.dart';

class Camera extends Item<Camera> {
  const Camera({
    required this.id,
    required this.label,
    required this.shutterSpeeds,
    required this.defaultFramesPerFilm,
  });

  final String id;
  final String label;
  final List<double> shutterSpeeds;
  final int? defaultFramesPerFilm;

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'shutterSpeeds': shutterSpeeds,
        'defaultFramesPerFilm': defaultFramesPerFilm,
      };

  @override
  String itemId() => id;

  @override
  String sortKey() => label;

  @override
  bool operator ==(Object other) =>
      other is Camera &&
      id == other.id &&
      label == other.label &&
      sameList(shutterSpeeds, other.shutterSpeeds) &&
      defaultFramesPerFilm == other.defaultFramesPerFilm;

  @override
  int get hashCode => Object.hashAll([
        id,
        label,
        ...shutterSpeeds,
        defaultFramesPerFilm,
      ]);
}
