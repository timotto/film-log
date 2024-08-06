import 'package:film_log/model/equals.dart';
import 'package:film_log/model/json.dart';

class Location implements ToJson, Equals<Location> {
  final double? latitude;
  final double? longitude;
  final double? height;

  /// [accuracy] is the expected error in meters.
  final double? accuracy;

  Location({
    this.latitude,
    this.longitude,
    this.height,
    this.accuracy,
  });

  bool get hasValue => latitude != null && longitude != null;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        latitude: json['latitude'],
        longitude: json['longitude'],
        height: json['height'],
        accuracy: json['accuracy'],
      );

  @override
  Map<String, dynamic> toJson() => {
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (height != null) 'height': height,
        if (accuracy != null) 'accuracy': accuracy,
      };

  @override
  String toString() =>
      '${latitude?.toStringAsFixed(5)}, ${longitude?.toStringAsFixed(5)}';

  @override
  bool equals(Location other) =>
      latitude == other.latitude &&
      longitude == other.longitude &&
      height == other.height &&
      accuracy == other.accuracy;

  static Location? tryParse(String value) {
    final parts = value.split(',');
    if (parts.length != 2) return null;
    final lat = double.tryParse(parts[0]);
    final lon = double.tryParse(parts[1]);
    if (lat == null || lon == null) return null;

    return Location(latitude: lat, longitude: lon);
  }
}
