import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_wear_os_location/flutter_wear_os_location.dart';
import 'package:flutter_wear_os_location/flutter_wear_os_location_platform_interface.dart';
import 'package:flutter_wear_os_location/flutter_wear_os_location_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterWearOsLocationPlatform
    with MockPlatformInterfaceMixin
    implements FlutterWearOsLocationPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterWearOsLocationPlatform initialPlatform = FlutterWearOsLocationPlatform.instance;

  test('$MethodChannelFlutterWearOsLocation is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterWearOsLocation>());
  });

  test('getPlatformVersion', () async {
    FlutterWearOsLocation flutterWearOsLocationPlugin = FlutterWearOsLocation();
    MockFlutterWearOsLocationPlatform fakePlatform = MockFlutterWearOsLocationPlatform();
    FlutterWearOsLocationPlatform.instance = fakePlatform;

    expect(await flutterWearOsLocationPlugin.getPlatformVersion(), '42');
  });
}
