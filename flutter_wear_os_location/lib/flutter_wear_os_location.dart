
import 'flutter_wear_os_location_platform_interface.dart';
import './model/location.dart';

class FlutterWearOsLocation {
  Future<String?> getPlatformVersion() {
    return FlutterWearOsLocationPlatform.instance.getPlatformVersion();
  }

  Future<Location?> getLocation() {
    return FlutterWearOsLocationPlatform.instance.getLocation();
  }

  Future<void> ensurePermission() async {
    await FlutterWearOsLocationPlatform.instance.ensurePermission();
  }
}
