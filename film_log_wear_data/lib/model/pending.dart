import 'package:film_log_wear_data/model/equals.dart';
import 'package:film_log_wear_data/model/json.dart';

import 'add_photo.dart';
import 'film.dart';
import 'photo.dart';
import 'state.dart';

/// [Pending] contains changes made by the Wear OS app pending to be
/// stored by the phone app. The Wear OS app syncs this item, the phone
/// app listens for them.
/// The Wear OS maintains the changes in this item until it receives
/// a confirmation of them being stored through the [State] object.
class Pending implements Equals<Pending> {
  const Pending({required this.addPhotos, required this.addFilms});

  factory Pending.empty() => const Pending(
        addPhotos: const [],
        addFilms: const [],
      );

  final List<AddPhoto> addPhotos;
  final List<Film> addFilms;

  bool get isEmpty => addPhotos.isEmpty && addFilms.isEmpty;

  Pending addItem(AddPhoto item) => Pending(
        addPhotos: [...addPhotos, item],
        addFilms: addFilms,
      );

  Pending addFilm(Film item) => Pending(
        addPhotos: addPhotos,
        addFilms: [...addFilms, item],
      );

  @override
  bool equals(Pending other) {
    if (addPhotos.length != other.addPhotos.length) return false;
    if (addFilms.length != other.addFilms.length) return false;

    if (!_sameAddPhotosByFilm(addPhotosByFilm, other.addPhotosByFilm)) {
      return false;
    }

    return Equals.all(addFilms, other.addFilms);
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

  factory Pending.fromJson(Map<String, dynamic> json) => Pending(
        addPhotos: allFromJson(json['addPhotos'], AddPhoto.fromJson),
        addFilms: allFromJson(json['addFilms'], Film.fromJson),
      );

  Map<String, dynamic> toJson() => {
        'addPhotos': allToJson(addPhotos),
        'addFilms': allToJson(addFilms),
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
    if (!Equals.all(photosA, photosB)) {
      return false;
    }
  }

  return true;
}
