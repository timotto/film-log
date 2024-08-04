import 'package:film_log_wear/model/location.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Location', (){
    late Location ref;
    late Location same;
    late Location otherLatitude;
    late Location otherLongitude;

    setUp((){
      // using "const Location" causes same hashCode for different objects!
      ref = Location(latitude: 10.12345, longitude: 50.54321);
      same = Location(latitude: 10.12345, longitude: 50.54321);
      otherLatitude = const Location(latitude: 11.12345, longitude: 50.54321);
      otherLongitude = const Location(latitude: 10.12345, longitude: 49.54321);
    });

    test('hashCode', () {
      expect(ref.hashCode, equals(same.hashCode));
      expect(ref.hashCode, isNot(equals(otherLatitude.hashCode)));
      expect(ref.hashCode, isNot(equals(otherLongitude.hashCode)));
    });

    test('==', () {
      expect(ref, equals(same));
      expect(ref, isNot(equals(otherLatitude)));
      expect(ref, isNot(equals(otherLongitude)));
    });
  });
}