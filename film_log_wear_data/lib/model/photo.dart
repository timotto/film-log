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

  bool equals(Photo other) =>
      id == other.id &&
      recorded.isAtSameMomentAs(other.recorded) &&
      frameNumber == other.frameNumber &&
      shutterSpeed == other.shutterSpeed &&
      aperture == other.aperture &&
      lensId == other.lensId &&
      _sameList(filterIdList, other.filterIdList) &&
      _sameLocation(location, other.location);

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

  static int compare(Photo a, Photo b) {
    final byFrame = a.frameNumber.compareTo(b.frameNumber);
    if (byFrame != 0) {
      return byFrame;
    }
    final byRecorded = a.recorded.compareTo(b.recorded);
    if (byRecorded != 0) {
      return byRecorded;
    }
    return a.id.compareTo(b.id);
  }
}

bool _sameList(List<String> a, List<String> b) {
  if (a.length != b.length) return false;
  final n = a.length;
  for (var i = 0; i < n; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

bool _sameLocation(Location? a, Location? b) {
  if (a == null && b == null) return true;
  if (a == null || b == null) return false;
  return a.equals(b);
}
