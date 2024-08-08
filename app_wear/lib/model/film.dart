import 'package:film_log_wear/model/util.dart';

import 'camera.dart';
import 'item.dart';
import 'photo.dart';

class Film extends Item<Film> {
  const Film({
    required this.id,
    required this.label,
    required this.inserted,
    required this.maxPhotoCount,
    required this.actualIso,
    required this.camera,
    required this.filmStockId,
    required this.photos,
  });

  final String id;
  final String label;
  final DateTime inserted;
  final int maxPhotoCount;
  final double? actualIso;
  final Camera? camera;
  final String? filmStockId;
  final List<Photo> photos;

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'inserted': inserted.toIso8601String(),
        'maxPhotoCount': maxPhotoCount,
        'actualIso': actualIso,
        'camera': camera?.toJson(),
        'filmStockId': filmStockId,
        'photos': photos.map((p) => p.toJson()).toList(),
      };

  Film addPhoto(Photo photo) => Film(
        id: id,
        label: label,
        inserted: inserted,
        maxPhotoCount: maxPhotoCount,
        actualIso: actualIso,
        camera: camera,
        filmStockId: filmStockId,
        photos: [...photos.where((p) => p.id != photo.id), photo],
      );

  bool canAddPhoto() => photos.length < maxPhotoCount;

  String listItemSubtitle() {
    final List<String> parts = [
      '${photos.length} / $maxPhotoCount',
      if (camera != null) camera!.label,
    ];

    return parts.join(' ');
  }

  @override
  String itemId() => id;

  @override
  String sortKey() => inserted.toIso8601String();

  @override
  bool operator ==(Object other) =>
      other is Film &&
      id == other.id &&
      label == other.label &&
      inserted == other.inserted &&
      maxPhotoCount == other.maxPhotoCount &&
      actualIso == other.actualIso &&
      camera == other.camera &&
      filmStockId == other.filmStockId &&
      sameList(photos, other.photos);

  @override
  int get hashCode => Object.hashAll([
        id,
        label,
        inserted,
        maxPhotoCount,
        actualIso,
        camera,
        filmStockId,
        ...photos,
      ]);
}
