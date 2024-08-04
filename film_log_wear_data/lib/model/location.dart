class Location {
  const Location({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;

  bool equals(Location other) =>
      latitude == other.latitude && longitude == other.longitude;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        latitude: json['latitude'],
        longitude: json['longitude'],
      );

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
      };

  @override
  bool operator ==(Object other) =>
      other is Location &&
      latitude == other.latitude &&
      longitude == other.longitude;

  @override
  int get hashCode => Object.hashAll([latitude, longitude]);
}
