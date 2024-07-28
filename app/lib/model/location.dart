class Location {
  final double latitude;
  final double longitude;
  final double height;

  /// [accuracy] is the expected error in meters.
  final double accuracy;

  Location({
    required this.latitude,
    required this.longitude,
    required this.height,
    required this.accuracy,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        latitude: json['latitude'],
        longitude: json['longitude'],
        height: json['height'],
        accuracy: json['accuracy'],
      );

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'height': height,
        'accuracy': accuracy,
      };
}
