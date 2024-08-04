import 'package:film_log_wear/model/camera.dart';
import 'package:film_log_wear/model/lens.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Lens', () {
    late Lens ref;
    late Lens same;
    late Lens otherId,
        otherLabel,
        otherApertures,
        otherCameras,
        reOrderedApertures,
        reOrderedCameras;

    late Camera cam1, cam2, cam3;

    setUp(() {
      cam1 = const Camera(
        id: 'cam-1',
        label: 'Camera 1',
        shutterSpeeds: [1 / 1000, 1 / 500, 1 / 250],
      );
      cam2 = const Camera(
        id: 'cam-2',
        label: 'Camera 2',
        shutterSpeeds: [1 / 125, 1 / 60, 1 / 30],
      );
      cam3 = const Camera(
        id: 'cam-3',
        label: 'Camera 3',
        shutterSpeeds: [1 / 125, 1 / 60, 1 / 30],
      );

      ref = Lens(
        id: 'lens-1',
        label: 'Lens 1',
        apertures: [2.8, 5.6, 8],
        cameras: [cam1, cam2],
      );

      same = Lens(
        id: 'lens-1',
        label: 'Lens 1',
        apertures: [2.8, 5.6, 8],
        cameras: [cam1, cam2],
      );

      otherId = Lens(
        id: 'lens-2',
        label: 'Lens 1',
        apertures: [2.8, 5.6, 8],
        cameras: [cam1, cam2],
      );

      otherLabel = Lens(
        id: 'lens-1',
        label: 'Lens 2',
        apertures: [2.8, 5.6, 8],
        cameras: [cam1, cam2],
      );

      otherApertures = Lens(
        id: 'lens-1',
        label: 'Lens 1',
        apertures: [2.8, 5.6, 8, 11, 16],
        cameras: [cam1, cam2],
      );

      otherCameras = Lens(
        id: 'lens-1',
        label: 'Lens 1',
        apertures: [2.8, 5.6, 8],
        cameras: [cam2, cam3],
      );

      reOrderedApertures = Lens(
        id: 'lens-1',
        label: 'Lens 1',
        apertures: [8, 5.6, 2.8],
        cameras: [cam1, cam2],
      );

      reOrderedCameras = Lens(
        id: 'lens-1',
        label: 'Lens 1',
        apertures: [2.8, 5.6, 8],
        cameras: [cam2, cam1],
      );
    });

    test('hashCode', () {
      expect(ref.hashCode, equals(same.hashCode));
      expect(ref.hashCode, isNot(equals(otherId.hashCode)));
      expect(ref.hashCode, isNot(equals(otherLabel.hashCode)));
      expect(ref.hashCode, isNot(equals(otherApertures.hashCode)));
      expect(ref.hashCode, isNot(equals(otherCameras.hashCode)));
      expect(ref.hashCode, isNot(equals(reOrderedApertures.hashCode)));
      expect(ref.hashCode, isNot(equals(reOrderedCameras.hashCode)));
    });

    test('==', () {
      expect(ref, equals(same));
      expect(ref, isNot(equals(otherId)));
      expect(ref, isNot(equals(otherLabel)));
      expect(ref, isNot(equals(otherApertures)));
      expect(ref, isNot(equals(otherCameras)));
      expect(ref, isNot(equals(reOrderedApertures)));
      expect(ref, isNot(equals(reOrderedCameras)));
    });
  });
}
