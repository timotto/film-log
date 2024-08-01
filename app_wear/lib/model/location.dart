class Location {
  Location({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;

  String listItemSubtitle() => '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
}
