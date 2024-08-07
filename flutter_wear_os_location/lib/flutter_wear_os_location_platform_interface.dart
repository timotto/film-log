import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import './model/location.dart';
import 'flutter_wear_os_location_method_channel.dart';

abstract class FlutterWearOsLocationPlatform extends PlatformInterface {
  /// Constructs a FlutterWearOsLocationPlatform.
  FlutterWearOsLocationPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterWearOsLocationPlatform _instance =
      MethodChannelFlutterWearOsLocation();

  /// The default instance of [FlutterWearOsLocationPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterWearOsLocation].
  static FlutterWearOsLocationPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterWearOsLocationPlatform] when
  /// they register themselves.
  static set instance(FlutterWearOsLocationPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<Location?> getLocation() {
    throw UnimplementedError('getLocation() has not been implemented.');
  }

  Future<bool> hasGps() {
    throw UnimplementedError('hasGps() has not been implemented.');
  }

  Future<void> ensurePermission() {
    throw UnimplementedError('ensurePermission() has not been implemented.');
  }
}
