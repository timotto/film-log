import 'package:location/location.dart';

import '../model/location.dart' as l;

Future<l.Location?> getLocation() async {
  Location location = Location();

  var serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return null;
    }
  }

  var permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }

  try {
    final data = await location.getLocation();
    if (data.latitude != null && data.longitude != null) {
      return l.Location(
        latitude: data.latitude,
        longitude: data.longitude,
        height: data.altitude,
        accuracy: data.accuracy,
      );
    }
  } catch (_) {}
  return null;
}
