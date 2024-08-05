import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_wear_os_location/flutter_wear_os_location.dart';
import 'package:flutter_wear_os_location/flutter_wear_os_location_platform_interface.dart';
import 'package:flutter_wear_os_location/flutter_wear_os_location_method_channel.dart';
import 'package:flutter_wear_os_location/model/location.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterWearOsLocationPlatform
    with MockPlatformInterfaceMixin
    implements FlutterWearOsLocationPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<void> ensurePermission() => Future.value();

  @override
  Future<Location?> getLocation() {
    return Future.value(const Location(
      latitude: 50.0870393,
      longitude: 14.4204258,
      altitude: 10,
      accuracy: 2,
    ));
  }

  @override
  Future<bool> hasGps() => Future.value(true);
}

void main() {
  final FlutterWearOsLocationPlatform initialPlatform =
      FlutterWearOsLocationPlatform.instance;

  test('$MethodChannelFlutterWearOsLocation is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterWearOsLocation>());
  });

  test('getPlatformVersion', () async {
    FlutterWearOsLocation flutterWearOsLocationPlugin = FlutterWearOsLocation();
    MockFlutterWearOsLocationPlatform fakePlatform =
        MockFlutterWearOsLocationPlatform();
    FlutterWearOsLocationPlatform.instance = fakePlatform;

    expect(await flutterWearOsLocationPlugin.getPlatformVersion(), '42');
  });

  test('getLocation', () async {
    FlutterWearOsLocation flutterWearOsLocationPlugin = FlutterWearOsLocation();
    MockFlutterWearOsLocationPlatform fakePlatform =
        MockFlutterWearOsLocationPlatform();
    FlutterWearOsLocationPlatform.instance = fakePlatform;

    expect(
        await flutterWearOsLocationPlugin.getLocation(),
        const Location(
          latitude: 50.0870393,
          longitude: 14.4204258,
          altitude: 10,
          accuracy: 2,
        ));
  });
}
