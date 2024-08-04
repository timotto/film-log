import 'package:film_log_wear/model/camera.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Camera', () {
    late Camera ref;
    late Camera same;
    late Camera otherId, otherLabel, otherShutterSpeeds, reOrderedShutterSpeeds;

    setUp((){
       ref = const Camera(
        id: 'id-1',
        label: 'Label 1',
        shutterSpeeds: [1, 2, 3],
      );

       same = const Camera(
        id: 'id-1',
        label: 'Label 1',
        shutterSpeeds: [1, 2, 3],
      );

       otherId = const Camera(
        id: 'id-2',
        label: 'Label 1',
        shutterSpeeds: [1, 2, 3],
      );

       otherLabel = const Camera(
        id: 'id-1',
        label: 'Label 2',
        shutterSpeeds: [1, 2, 3],
      );

       otherShutterSpeeds = const Camera(
        id: 'id-1',
        label: 'Label 1',
        shutterSpeeds: [4,5,6],
      );

       reOrderedShutterSpeeds = const Camera(
        id: 'id-1',
        label: 'Label 1',
        shutterSpeeds: [1, 3, 2],
      );
    });

    test('hashCode', () {
      expect(ref.hashCode, equals(same.hashCode));
      expect(ref.hashCode, isNot(equals(otherId.hashCode)));
      expect(ref.hashCode, isNot(equals(otherLabel.hashCode)));
      expect(ref.hashCode, isNot(equals(otherShutterSpeeds.hashCode)));
      expect(ref.hashCode, isNot(equals(reOrderedShutterSpeeds.hashCode)));
    });

    test('==', () {
      expect(ref, equals(same));
      expect(ref, isNot(equals(otherId)));
      expect(ref, isNot(equals(otherLabel)));
      expect(ref, isNot(equals(otherShutterSpeeds)));
      expect(ref, isNot(equals(reOrderedShutterSpeeds)));
    });
  });
}
