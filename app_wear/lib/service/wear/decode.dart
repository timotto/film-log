import 'package:film_log_wear_data/model/camera.dart' as w;
import 'package:film_log_wear_data/model/film.dart' as w;
import 'package:film_log_wear_data/model/film_stock.dart' as w;
import 'package:film_log_wear_data/model/filter.dart' as w;
import 'package:film_log_wear_data/model/lens.dart' as w;
import 'package:film_log_wear_data/model/location.dart' as w;
import 'package:film_log_wear_data/model/photo.dart' as w;

import '../../model/camera.dart' as m;
import '../../model/film.dart' as m;
import '../../model/filmstock.dart' as m;
import '../../model/filter.dart' as m;
import '../../model/lens.dart' as m;
import '../../model/location.dart' as m;
import '../../model/photo.dart' as m;

m.Film decodeFilm(
  w.Film item, {
  required List<m.Camera> cameras,
  required List<m.Filter> filters,
  required List<m.Lens> lenses,
}) =>
    m.Film(
      id: item.id,
      label: item.name,
      inserted: item.inserted,
      maxPhotoCount: item.maxPhotoCount,
      camera: cameras.where((camera) => camera.id == item.cameraId).firstOrNull,
      actualIso: item.actualIso,
      filmStockId: item.filmStockId,
      photos: item.photos
          .map((item) => decodePhoto(
                item,
                filters: filters,
                lenses: lenses,
              ))
          .toList(growable: false),
    );

m.Photo decodePhoto(
  w.Photo item, {
  required List<m.Lens> lenses,
  required List<m.Filter> filters,
}) =>
    m.Photo(
      id: item.id,
      frameNumber: item.frameNumber,
      recorded: item.recorded,
      shutterSpeed: item.shutterSpeed,
      aperture: item.aperture,
      lens: lenses.where((lens) => lens.id == item.lensId).firstOrNull,
      filters: filters
          .where((filter) => item.filterIdList
              .where((filterId) => filter.id == filterId)
              .isNotEmpty)
          .toList(growable: false),
      location: decodeLocation(item.location),
    );

m.Location? decodeLocation(w.Location? item) => item == null
    ? null
    : m.Location(
        latitude: item.latitude,
        longitude: item.longitude,
      );

m.Camera? decodeCamera(w.Camera? item) => item == null
    ? null
    : m.Camera(
        id: item.id,
        label: item.label,
        shutterSpeeds: item.shutterSpeeds,
        defaultFramesPerFilm: item.defaultFramesPerFilm,
      );

m.Lens? decodeLens(
  w.Lens? item, {
  required List<m.Camera> cameras,
}) =>
    item == null
        ? null
        : m.Lens(
            id: item.id,
            label: item.label,
            apertures: item.apertures,
            cameras: cameras
                .where((camera) => item.cameraIds.contains(camera.id))
                .toList(growable: false),
          );

m.Filter? decodeFilter(
  w.Filter? item, {
  required List<m.Lens> lenses,
}) =>
    item == null
        ? null
        : m.Filter(
            id: item.id,
            label: item.label,
            lenses: lenses
                .where((lens) => item.lensIdList.contains(lens.id))
                .toList(growable: false),
          );

m.FilmStock decodeFilmStock(
  w.FilmStock item, {
  required List<m.Camera> cameras,
}) =>
    m.FilmStock(
      id: item.id,
      label: item.label,
      iso: item.iso,
      cameras: cameras
          .where((camera) => item.cameraIds.contains(camera.id))
          .toList(growable: false),
    );
