import 'package:film_log_wear/model/camera.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Camera', () {
    late Camera ref;
    late Camera same;
    late Camera otherId,
        otherLabel,
        otherShutterSpeeds,
        reOrderedShutterSpeeds,
        otherDefaultFramesPerFilm;

    setUp(() {
      ref = const Camera(
        id: 'id-1',
        label: 'Label 1',
        shutterSpeeds: [1, 2, 3],
        defaultFramesPerFilm: 36,
      );

      same = const Camera(
        id: 'id-1',
        label: 'Label 1',
        shutterSpeeds: [1, 2, 3],
        defaultFramesPerFilm: 36,
      );

      otherId = const Camera(
        id: 'id-2',
        label: 'Label 1',
        shutterSpeeds: [1, 2, 3],
        defaultFramesPerFilm: 36,
      );

      otherLabel = const Camera(
        id: 'id-1',
        label: 'Label 2',
        shutterSpeeds: [1, 2, 3],
        defaultFramesPerFilm: 36,
      );

      otherShutterSpeeds = const Camera(
        id: 'id-1',
        label: 'Label 1',
        shutterSpeeds: [4, 5, 6],
        defaultFramesPerFilm: 36,
      );

      reOrderedShutterSpeeds = const Camera(
        id: 'id-1',
        label: 'Label 1',
        shutterSpeeds: [1, 3, 2],
        defaultFramesPerFilm: 36,
      );

      otherDefaultFramesPerFilm = const Camera(
        id: 'id-1',
        label: 'Label 1',
        shutterSpeeds: [1, 2, 3],
        defaultFramesPerFilm: 24,
      );
    });

    test('hashCode', () {
      expect(ref.hashCode, equals(same.hashCode));
      expect(ref.hashCode, isNot(equals(otherId.hashCode)));
      expect(ref.hashCode, isNot(equals(otherLabel.hashCode)));
      expect(ref.hashCode, isNot(equals(otherShutterSpeeds.hashCode)));
      expect(ref.hashCode, isNot(equals(reOrderedShutterSpeeds.hashCode)));
      expect(ref.hashCode, isNot(equals(otherDefaultFramesPerFilm.hashCode)));
    });

    test('==', () {
      expect(ref, equals(same));
      expect(ref, isNot(equals(otherId)));
      expect(ref, isNot(equals(otherLabel)));
      expect(ref, isNot(equals(otherShutterSpeeds)));
      expect(ref, isNot(equals(reOrderedShutterSpeeds)));
      expect(ref, isNot(equals(otherDefaultFramesPerFilm)));
    });
  });
}
