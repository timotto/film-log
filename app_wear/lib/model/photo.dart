import 'filter.dart';
import 'lens.dart';
import 'location.dart';

class Photo {
  final String id;
  final int frameNumber;
  final DateTime recorded;
  final double? shutterSpeed;
  final double? aperture;
  final Lens? lens;
  final List<Filter> filters;
  final Location? location;

  Photo({
    required this.id,
    required this.frameNumber,
    required this.recorded,
    required this.shutterSpeed,
    required this.aperture,
    required this.lens,
    required this.filters,
    required this.location,
  });

  Photo update({
    DateTime? recorded,
    int? frameNumber,
    double? shutterSpeed,
    double? aperture,
    Lens? lens,
    List<Filter>? filters,
    Location? location,
  }) =>
      Photo(
        id: id,
        frameNumber: frameNumber ?? this.frameNumber,
        recorded: recorded ?? this.recorded,
        shutterSpeed: shutterSpeed ?? this.shutterSpeed,
        aperture: aperture ?? this.aperture,
        lens: lens ?? this.lens,
        filters: filters ?? this.filters,
        location: location ?? this.location,
      );
}
