import 'package:film_log_wear/fmt/aperture.dart';
import 'package:film_log_wear/fmt/shutter_speed.dart';
import 'package:film_log_wear/model/util.dart';

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

  Map<String, dynamic> toJson() => {
    'id':id,
    'frameNumber':frameNumber,
    'recorded':recorded.toIso8601String(),
    'shutterSpeed':shutterSpeed,
    'aperture':aperture,
    'lens':lens?.toJson(),
    'filters':filters.map((f) => f.toJson()).toList(),
    'location':location?.toJson(),
  };

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

  String? listItemSubTitle() {
    List<String> parts = [
      if (shutterSpeed != null) formatShutterSpeed(shutterSpeed!),
      if (aperture != null) formatAperture(aperture!),
      if (lens != null) lens!.label,
    ];
    if (parts.isEmpty) return null;
    return parts.join(' ');
  }

  @override
  bool operator ==(Object other) =>
      other is Photo &&
      id == other.id &&
      frameNumber == other.frameNumber &&
      recorded == other.recorded &&
      shutterSpeed == other.shutterSpeed &&
      aperture == other.aperture &&
      lens == other.lens &&
      sameList(filters, other.filters) &&
      location == other.location;

  @override
  int get hashCode => Object.hashAll([
        id,
        frameNumber,
        recorded,
        shutterSpeed,
        aperture,
        lens,
        ...filters,
        location,
      ]);
}
