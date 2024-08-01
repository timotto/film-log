import 'package:film_log/model/filter.dart';
import 'package:film_log/model/lens.dart';
import 'package:film_log/model/location.dart' as m;
import 'package:film_log/model/photo.dart' as m;
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
      lens: lenses.where((lens) => lens.id == item.lensId).firstOrNull,
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
