import 'package:film_log_wear/model/camera.dart' as m;
import 'package:film_log_wear/model/film.dart' as m;
import 'package:film_log_wear/model/item.dart';
import 'package:film_log_wear/model/lens.dart' as m;
import 'package:film_log_wear/model/location.dart' as m;
import 'package:film_log_wear/model/photo.dart' as m;
import 'package:film_log_wear_data/model/film.dart' as w;
import 'package:film_log_wear_data/model/location.dart' as w;
import 'package:film_log_wear_data/model/photo.dart' as w;

w.Photo encodePhoto(m.Photo item) => w.Photo(
      id: item.id,
      recorded: item.recorded,
      frameNumber: item.frameNumber,
      shutterSpeed: item.shutterSpeed,
      aperture: item.aperture,
      lensId: item.lens?.id,
      filterIdList:
          item.filters.map((filter) => filter.id).toList(growable: false),
      location: encodeLocation(item.location),
    );

w.Location? encodeLocation(m.Location? item) => item == null
    ? null
    : w.Location(
        latitude: item.latitude,
        longitude: item.longitude,
      );

w.Film encodeFilm(
  m.Film item, {
  required List<m.Lens> lenses,
}) =>
    w.Film(
      id: item.id,
      name: item.label,
      inserted: item.inserted,
      cameraId: item.camera?.id,
      maxPhotoCount: item.maxPhotoCount,
      actualIso: item.actualIso,
      filmStockId: item.filmStockId,
      lensIdList: item.camera == null
          ? []
          : lenses
              .where((lens) => contains<m.Camera>(lens.cameras, item.camera!))
              .map((lens) => lens.id)
              .toList(growable: false),
      photos: item.photos.map(encodePhoto).toList(growable: false),
    );
