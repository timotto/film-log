import 'package:film_log_wear/model/util.dart';

import 'camera.dart';
import 'item.dart';

class Lens extends Item<Lens> {
  Lens({
    required this.id,
    required this.label,
    required this.apertures,
    required this.cameras,
  });

  final String id;
  final String label;
  final List<double> apertures;
  final List<Camera> cameras;

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'apertures': apertures,
        'cameras': cameras.map((c) => c.toJson()).toList(),
      };

  @override
  String itemId() => id;

  @override
  String sortKey() => label;

  @override
  bool operator ==(Object other) =>
      other is Lens &&
      id == other.id &&
      label == other.label &&
      sameList(apertures, other.apertures) &&
      sameList(cameras, other.cameras);

  @override
  int get hashCode => Object.hashAll([id, label, ...apertures, ...cameras]);
}
