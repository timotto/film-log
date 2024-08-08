import 'package:film_log_wear/model/util.dart';

import 'camera.dart';
import 'item.dart';

class FilmStock extends Item<FilmStock> {
  const FilmStock({
    required this.id,
    required this.label,
    required this.iso,
    required this.cameras,
  });

  final String id;
  final String label;
  final double iso;
  final List<Camera> cameras;

  @override
  String itemId() => id;

  @override
  String sortKey() => label;

  @override
  bool operator ==(Object other) =>
      other is FilmStock &&
      id == other.id &&
      label == other.label &&
      iso == other.iso &&
      sameList(cameras, other.cameras);

  @override
  int get hashCode => Object.hashAll([id, label, iso, ...cameras]);
}
