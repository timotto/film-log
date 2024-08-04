import 'package:film_log_wear/model/filter.dart';
import 'package:film_log_wear/model/lens.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Filter', () {
    late Filter ref;
    late Filter same;
    late Filter otherId, otherLabel, otherLenses, reOrderedLenses;

    late Lens lens1, lens2, lens3, lens4;

    setUp(() {
      lens1 = Lens(
        id: 'lens-1',
        label: 'Lens 1',
        apertures: [1, 2, 3],
        cameras: [],
      );
      lens2 = Lens(
        id: 'lens-2',
        label: 'Lens 2',
        apertures: [1, 2, 3],
        cameras: [],
      );
      lens3 = Lens(
        id: 'lens-3',
        label: 'Lens 3',
        apertures: [1, 2, 3],
        cameras: [],
      );
      lens4 = Lens(
        id: 'lens-4',
        label: 'Lens 4',
        apertures: [1, 2, 3],
        cameras: [],
      );

      ref = Filter(
        id: 'filter-1',
        label: 'Filter 1',
        lenses: [lens1, lens2, lens3],
      );
      same = Filter(
        id: 'filter-1',
        label: 'Filter 1',
        lenses: [lens1, lens2, lens3],
      );
      otherId = Filter(
        id: 'filter-2',
        label: 'Filter 1',
        lenses: [lens1, lens2, lens3],
      );
      otherLabel = Filter(
        id: 'filter-1',
        label: 'Filter 2',
        lenses: [lens1, lens2, lens3],
      );
      otherLenses = Filter(
        id: 'filter-1',
        label: 'Filter 1',
        lenses: [lens1, lens2, lens4],
      );
      reOrderedLenses = Filter(
        id: 'filter-1',
        label: 'Filter 1',
        lenses: [lens3, lens2, lens1],
      );
    });

    test('hashCode', () {
      expect(ref.hashCode, equals(same.hashCode));
      expect(ref.hashCode, isNot(equals(otherId.hashCode)));
      expect(ref.hashCode, isNot(equals(otherLabel.hashCode)));
      expect(ref.hashCode, isNot(equals(otherLenses.hashCode)));
      expect(ref.hashCode, isNot(equals(reOrderedLenses.hashCode)));
    });

    test('==', () {
      expect(ref, equals(same));
      expect(ref, isNot(equals(otherId)));
      expect(ref, isNot(equals(otherLabel)));
      expect(ref, isNot(equals(otherLenses)));
      expect(ref, isNot(equals(reOrderedLenses)));
    });
  });
}
