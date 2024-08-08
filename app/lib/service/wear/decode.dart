import 'package:film_log/model/camera.dart';
import 'package:film_log/model/film_instance.dart';
import 'package:film_log/model/film_stock.dart';
import 'package:film_log/model/filter.dart';
import 'package:film_log/model/gear.dart';
import 'package:film_log/model/lens.dart';
import 'package:film_log/model/location.dart' as m;
import 'package:film_log/model/photo.dart' as m;
import 'package:film_log_wear_data/model/film.dart' as w;
import 'package:film_log_wear_data/model/location.dart' as w;
import 'package:film_log_wear_data/model/photo.dart' as w;

m.Photo decodePhoto(
  w.Photo item, {
  required List<Lens> lenses,
  required List<Filter> filters,
}) =>
    m.Photo(
      id: item.id,
      timestamp: item.recorded,
      frameNumber: item.frameNumber,
      shutter: item.shutterSpeed,
      aperture: item.aperture,
      lens: _gearById(lenses, item.lensId),
      filters: filters
          .where((filter) => item.filterIdList.contains(filter.id))
          .toList(growable: false),
      location: parseLocation(item.location),
      thumbnail: null,
      notes: null,
    );

m.Location? parseLocation(w.Location? item) => item == null
    ? null
    : m.Location(
        latitude: item.latitude,
        longitude: item.longitude,
      );

FilmInstance decodeFilmInstance(
  w.Film item, {
  required List<Camera> cameras,
  required List<FilmStock> filmStocks,
  required List<Lens> lenses,
  required List<Filter> filters,
}) =>
    FilmInstance(
      id: item.id,
      name: item.name,
      inserted: item.inserted,
      maxPhotoCount: item.maxPhotoCount,
      archive: false,
      actualIso: item.actualIso ?? 100,
      stock: _gearById(filmStocks, item.filmStockId),
      camera: _gearById(cameras, item.cameraId),
      photos: item.photos
          .map((photo) => decodePhoto(
                photo,
                lenses: lenses,
                filters: filters,
              ))
          .toList(growable: false),
    );

T? _gearById<T extends Gear>(List<T> items, String? id) =>
    id == null ? null : items.where((item) => item.itemId() == id).firstOrNull;
