import 'package:film_log_wear/model/location.dart' as m;
import 'package:film_log_wear/model/photo.dart' as m;
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
