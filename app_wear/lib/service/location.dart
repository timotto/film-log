import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wear_os_location/flutter_wear_os_location.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../model/location.dart';

const _mapsPlaysStoreUrl =
    "https://play.google.com/store/apps/details?id=com.google.android.apps.maps";

Future<Location?> getLocation() async {
  final svc = FlutterWearOsLocation();
  final location = await svc.getLocation();
  if (location == null) return null;

  return Location(
    latitude: location.latitude,
    longitude: location.longitude,
  );
}

Future<void> openLocation(BuildContext context, Location location) async {
  try {
    if (await _openGoogleMaps(location)) {
      return;
    }
  } catch (e) {
    if (!(e is PlatformException && e.code == 'ACTIVITY_NOT_FOUND')) {
      return;
    }
  }

  await _installGoogleMaps();
}

Future<bool> _openGoogleMaps(Location location) async {
  final result = await MapsLauncher.launchCoordinates(
      location.latitude, location.longitude);
  return result;
}

Future<bool> _installGoogleMaps() async {
  try {
    final result = await launchUrlString(_mapsPlaysStoreUrl);
    if (result) {
      return true;
    }
  } catch (e) {
    print('error while opening maps play store url:');
    print(e);
  }

  return false;
}
