import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_wear_os_location/flutter_wear_os_location_method_channel.dart';
import 'package:flutter_wear_os_location/model/location.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFlutterWearOsLocation platform =
      MethodChannelFlutterWearOsLocation();
  const MethodChannel channel = MethodChannel('flutter_wear_os_location');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'getPlatformVersion':
            return '42';

          case 'ensurePermission':
            return '';

          case 'hasGps':
            return true;

          case 'getLocation':
            return {
              'latitude': 50.0870393,
              'longitude': 14.4204258,
              'altitude': 10.0,
              'accuracy': 2.0,
            };
        }

        throw 'method not mocked';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });

  test('hasGps', () async {
    expect(await platform.hasGps(), true);
  });

  test('getLocation', () async {
    expect(
        await platform.getLocation(),
        const Location(
          latitude: 50.0870393,
          longitude: 14.4204258,
          altitude: 10,
          accuracy: 2,
        ));
  });
}
