import 'package:film_log/model/film_instance.dart';
import 'package:film_log/model/filter.dart' as m;
import 'package:film_log/model/lens.dart' as m;
import 'package:film_log/model/location.dart' as m;
import 'package:film_log/model/photo.dart' as m;
import 'package:film_log/model/camera.dart' as m;
import 'package:film_log_wear_data/model/film.dart' as w;
import 'package:film_log_wear_data/model/filter.dart' as w;
import 'package:film_log_wear_data/model/lens.dart' as w;
import 'package:film_log_wear_data/model/location.dart' as w;
import 'package:film_log_wear_data/model/photo.dart' as w;
import 'package:film_log_wear_data/model/camera.dart' as w;

w.Location? encodeLocation(m.Location? value) {
  if (value == null || value.latitude == null || value.longitude == null) {
    return null;
  }
  return w.Location(
    latitude: value.latitude!,
    longitude: value.longitude!,
  );
}

w.Photo encodePhoto(m.Photo item) => w.Photo(
      id: item.id,
      recorded: item.timestamp,
      frameNumber: item.frameNumber,
      shutterSpeed: item.shutter,
      aperture: item.aperture,
      lensId: item.lens?.id,
      filterIdList: item.filters.map((item) => item.id).toList(growable: false),
      location: encodeLocation(item.location),
    );

w.Film encodeFilm(FilmInstance item, {required List<m.Lens> lenses}) => w.Film(
      id: item.id,
      name: item.name,
      inserted: item.inserted,
      cameraId: item.camera?.id,
      photos:
          item.photos.map((item) => encodePhoto(item)).toList(growable: false),
      maxPhotoCount: item.maxPhotoCount,
      lensIdList: lenses
          .where((lens) => lens.cameras
              .where((camera) => camera.id == item.camera?.id)
              .isNotEmpty)
          .map((lens) => lens.id)
          .toList(growable: false),
    );

w.Filter encodeFilter(m.Filter item) => w.Filter(
    id: item.id,
    label: item.name,
    lensIdList: item.lenses.map((item) => item.id).toList(growable: false));

w.Lens encodeLens(m.Lens item) => w.Lens(
      id: item.id,
      label: item.name,
      apertures: item.apertures(),
      cameraIds:
          item.cameras.map((camera) => camera.id).toList(growable: false),
    );

w.Camera encodeCamera(m.Camera item) => w.Camera(
      id: item.id,
      label: item.name,
      shutterSpeeds: item.shutterSpeeds(),
    );
