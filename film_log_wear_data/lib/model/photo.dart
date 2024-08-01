import 'package:film_log_wear_data/model/json.dart';

import 'location.dart';

class Photo {
  const Photo({
    required this.id,
    required this.recorded,
    required this.frameNumber,
    required this.shutterSpeed,
    required this.aperture,
    required this.lensId,
    required this.filterIdList,
    required this.location,
  });

  final String id;
  final DateTime recorded;
  final int frameNumber;
  final double? shutterSpeed;
  final double? aperture;
  final String? lensId;
  final List<String> filterIdList;
  final Location? location;

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        id: json['id'],
        recorded: DateTime.parse(json['recorded']),
        frameNumber: json['frameNumber'],
        shutterSpeed: json['shutterSpeed'],
        aperture: json['aperture'],
        lensId: json['lensId'],
        filterIdList: typedList<String>(json['filterIdList']),
        location: json['location'] == null
            ? null
            : Location.fromJson(json['location']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'recorded': recorded.toIso8601String(),
        'frameNumber': frameNumber,
        'shutterSpeed': shutterSpeed,
        'aperture': aperture,
        'lensId': lensId,
        'filterIdList': filterIdList,
        'location': location?.toJson(),
      };
}
