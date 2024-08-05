class Location {
  const Location({
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.accuracy,
  });

  final double latitude;
  final double longitude;
  final double altitude;
  final double accuracy;

  @override
  bool operator ==(Object other) =>
      other is Location &&
      latitude == other.latitude &&
      longitude == other.longitude &&
      altitude == other.altitude &&
      accuracy == other.accuracy;

  @override
  int get hashCode => Object.hashAll([
        latitude,
        longitude,
        altitude,
        accuracy,
      ]);
}
