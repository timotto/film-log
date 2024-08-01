import 'camera.dart';
import 'photo.dart';

class Film {
  const Film({
    required this.id,
    required this.label,
    required this.inserted,
    required this.maxPhotoCount,
    required this.camera,
    required this.photos,
  });

  final String id;
  final String label;
  final DateTime inserted;
  final int maxPhotoCount;
  final Camera? camera;
  final List<Photo> photos;

  Film addPhoto(Photo photo) => Film(
        id: id,
        label: label,
        inserted: inserted,
        maxPhotoCount: maxPhotoCount,
        camera: camera,
        photos: [...photos, photo],
      );

  bool canAddPhoto() => photos.length < maxPhotoCount;
}
