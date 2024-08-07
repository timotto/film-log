import './model/location.dart';
import 'flutter_wear_os_location_platform_interface.dart';

class FlutterWearOsLocation {
  Future<String?> getPlatformVersion() =>
      FlutterWearOsLocationPlatform.instance.getPlatformVersion();

  Future<Location?> getLocation() =>
      FlutterWearOsLocationPlatform.instance.getLocation();

  Future<void> ensurePermission() async =>
      await FlutterWearOsLocationPlatform.instance.ensurePermission();
}
