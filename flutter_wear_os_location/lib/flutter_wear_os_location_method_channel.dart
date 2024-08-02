import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_wear_os_location_platform_interface.dart';

import './model/location.dart';

/// An implementation of [FlutterWearOsLocationPlatform] that uses method channels.
class MethodChannelFlutterWearOsLocation extends FlutterWearOsLocationPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_wear_os_location');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<Location?> getLocation() async {
    final data =
        await methodChannel.invokeMethod<Map<Object?, Object?>>('getLocation');
    if (data == null) return null;

    final latitude = data['latitude'] as double;
    final longitude = data['longitude'] as double;
    final altitude = data['altitude'] as double;
    final accuracy = data['accuracy'] as double;

    if (latitude == null ||
        longitude == null ||
        altitude == null ||
        accuracy == null) {
      return null;
    }

    return Location(
      latitude: latitude,
      longitude: longitude,
      altitude: altitude,
      accuracy: accuracy,
    );
  }

  @override
  Future<bool> hasGps() async {
    final result = await methodChannel.invokeMethod<bool>('hasGps');
    return result ?? false;
  }

  @override
  Future<void> ensurePermission() async {
    await methodChannel.invokeMethod<bool>('ensurePermission');
  }
}
