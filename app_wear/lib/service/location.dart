import 'package:flutter_wear_os_location/flutter_wear_os_location.dart';

import '../model/location.dart';

Future<Location?> getLocation() async {
  final svc = FlutterWearOsLocation();
  final location = await svc.getLocation();
  if (location == null) return null;

  return Location(
    latitude: location.latitude,
    longitude: location.longitude,
  );
}
