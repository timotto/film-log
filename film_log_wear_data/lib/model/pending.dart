import 'add_photo.dart';
import 'photo.dart';
import 'state.dart';

/// [Pending] contains changes made by the Wear OS app pending to be
/// stored by the phone app. The Wear OS app syncs this item, the phone
/// app listens for them.
/// The Wear OS maintains the changes in this item until it receives
/// a confirmation of them being stored through the [State] object.
class Pending {
  const Pending({required this.addPhotos});

  final List<AddPhoto> addPhotos;

  bool get isEmpty => addPhotos.isEmpty;

  Pending addItem(AddPhoto item) => Pending(addPhotos: [...addPhotos, item]);

  bool equals(Pending other) {
    if (addPhotos.length != other.addPhotos.length) return false;

    return _sameAddPhotosByFilm(addPhotosByFilm, other.addPhotosByFilm);
  }

  Map<String, List<Photo>> get addPhotosByFilm {
    final Map<String, List<Photo>> result = {};
    for (var item in addPhotos) {
      final photos = result[item.filmId];
      if (photos == null) {
        result[item.filmId] = [item.photo];
      } else {
        result[item.filmId] = [...photos, item.photo];
        result[item.filmId]!.sort(Photo.compare);
      }
    }

    return result;
  }

  Pending withState(State state) {
    final List<AddPhoto> missing = [];

    for (var addPhoto in addPhotos) {
      final film =
          state.films.where((film) => film.id == addPhoto.filmId).firstOrNull;
      if (film == null) {
        print(
            'pending::with-state: warning: add-photo with unknown film id: ${addPhoto.filmId}');
        // TODO delete this photo?
        missing.add(addPhoto);
        continue;
      }

      final photo = film.photos
          .where((photo) => photo.id == addPhoto.photo.id)
          .firstOrNull;

      if (photo == null) {
        missing.add(addPhoto);
        continue;
      }
    }

    return Pending(addPhotos: missing);
  }

  factory Pending.fromJson(Map<String, dynamic> json) => Pending(
        addPhotos: (json['addPhotos'] as List<dynamic>)
            .map((j) => AddPhoto.fromJson(j))
            .toList(growable: false),
      );

  Map<String, dynamic> toJson() => {
        'addPhotos':
            addPhotos.map((item) => item.toJson()).toList(growable: false),
      };
}

bool _sameAddPhotosByFilm(
    Map<String, List<Photo>> a, Map<String, List<Photo>> b) {
  for (var filmId in a.keys) {
    final photosA = a[filmId];
    final photosB = b[filmId];
    if (photosA == null || photosB == null) {
      return false;
    }
    if (!_samePhotos(photosA, photosB)) {
      return false;
    }
  }

  return true;
}

bool _samePhotos(List<Photo> a, List<Photo> b) {
  if (a.length != b.length) {
    return false;
  }
  final n = a.length;
  for (var i = 0; i < n; i++) {
    final photoA = a[i];
    final photoB = b[i];
    if (!photoA.equals(photoB)) {
      return false;
    }
  }

  return true;
}
