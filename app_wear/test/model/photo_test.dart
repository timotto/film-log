import 'package:film_log_wear/model/camera.dart';
import 'package:film_log_wear/model/filter.dart';
import 'package:film_log_wear/model/lens.dart';
import 'package:film_log_wear/model/location.dart';
import 'package:film_log_wear/model/photo.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Photo', () {
    late Photo ref;
    late Photo same;
    late Photo otherId,
        otherFrameNumber,
        otherRecorded,
        otherShutterSpeed,
        nullShutterSpeed,
        otherAperture,
        nullAperture,
        otherLens,
        nullLens,
        otherFilters,
        emptyFilters,
        reOrderedFilters,
        otherLocation,
        nullLocation;

    late Camera camera1;
    late Lens lens1, lens2;
    late Filter filter1, filter2, filter3;

    setUp(() {
      camera1 = const Camera(
        id: 'camera-1',
        label: 'Camera 1',
        shutterSpeeds: [1 / 500, 1 / 250, 1 / 125, 1 / 60],
        defaultFramesPerFilm: 36,
      );
      lens1 = Lens(
          id: 'lens-1',
          label: 'Lens 1',
          apertures: [2.8, 5.6, 8, 11, 16],
          cameras: [camera1]);
      lens2 = Lens(
          id: 'lens-2',
          label: 'Lens 2',
          apertures: [2.8, 5.6, 8, 11, 16],
          cameras: [camera1]);
      filter1 = Filter(
        id: 'filter-1',
        label: 'Filter 1',
        lenses: [lens1],
      );
      filter2 = Filter(
        id: 'filter-2',
        label: 'Filter 2',
        lenses: [lens2],
      );
      filter3 = Filter(
        id: 'filter-3',
        label: 'Filter 3',
        lenses: [lens1, lens2],
      );

      ref = Photo(
        id: 'photo-1',
        frameNumber: 1,
        recorded: DateTime(2020, 1, 2, 3, 4, 5),
        shutterSpeed: 1 / 125,
        aperture: 11,
        lens: lens1,
        filters: [filter1, filter2],
        location: const Location(latitude: 10, longitude: 40),
      );
      same = Photo(
        id: 'photo-1',
        frameNumber: 1,
        recorded: DateTime(2020, 1, 2, 3, 4, 5),
        shutterSpeed: 1 / 125,
        aperture: 11,
        lens: lens1,
        filters: [filter1, filter2],
        location: const Location(latitude: 10, longitude: 40),
      );
      otherId = Photo(
        id: 'photo-2',
        frameNumber: 1,
        recorded: DateTime(2020, 1, 2, 3, 4, 5),
        shutterSpeed: 1 / 125,
        aperture: 11,
        lens: lens1,
        filters: [filter1, filter2],
        location: const Location(latitude: 10, longitude: 40),
      );
      otherFrameNumber = Photo(
        id: 'photo-1',
        frameNumber: 2,
        recorded: DateTime(2020, 1, 2, 3, 4, 5),
        shutterSpeed: 1 / 125,
        aperture: 11,
        lens: lens1,
        filters: [filter1, filter2],
        location: const Location(latitude: 10, longitude: 40),
      );
      otherRecorded = Photo(
        id: 'photo-1',
        frameNumber: 1,
        recorded: DateTime(2023, 1, 2, 3, 4, 5),
        shutterSpeed: 1 / 125,
        aperture: 11,
        lens: lens1,
        filters: [filter1, filter2],
        location: const Location(latitude: 10, longitude: 40),
      );
      otherShutterSpeed = Photo(
        id: 'photo-1',
        frameNumber: 1,
        recorded: DateTime(2020, 1, 2, 3, 4, 5),
        shutterSpeed: 1 / 250,
        aperture: 11,
        lens: lens1,
        filters: [filter1, filter2],
        location: const Location(latitude: 10, longitude: 40),
      );
      nullShutterSpeed = Photo(
        id: 'photo-1',
        frameNumber: 1,
        recorded: DateTime(2020, 1, 2, 3, 4, 5),
        shutterSpeed: null,
        aperture: 11,
        lens: lens1,
        filters: [filter1, filter2],
        location: const Location(latitude: 10, longitude: 40),
      );
      otherAperture = Photo(
        id: 'photo-1',
        frameNumber: 1,
        recorded: DateTime(2020, 1, 2, 3, 4, 5),
        shutterSpeed: 1 / 125,
        aperture: 8,
        lens: lens1,
        filters: [filter1, filter2],
        location: const Location(latitude: 10, longitude: 40),
      );
      nullAperture = Photo(
        id: 'photo-1',
        frameNumber: 1,
        recorded: DateTime(2020, 1, 2, 3, 4, 5),
        shutterSpeed: 1 / 125,
        aperture: null,
        lens: lens1,
        filters: [filter1, filter2],
        location: const Location(latitude: 10, longitude: 40),
      );
      otherLens = Photo(
        id: 'photo-1',
        frameNumber: 1,
        recorded: DateTime(2020, 1, 2, 3, 4, 5),
        shutterSpeed: 1 / 125,
        aperture: 11,
        lens: lens2,
        filters: [filter1, filter2],
        location: const Location(latitude: 10, longitude: 40),
      );
      nullLens = Photo(
        id: 'photo-1',
        frameNumber: 1,
        recorded: DateTime(2020, 1, 2, 3, 4, 5),
        shutterSpeed: 1 / 125,
        aperture: 11,
        lens: null,
        filters: [filter1, filter2],
        location: const Location(latitude: 10, longitude: 40),
      );
      otherFilters = Photo(
        id: 'photo-1',
        frameNumber: 1,
        recorded: DateTime(2020, 1, 2, 3, 4, 5),
        shutterSpeed: 1 / 125,
        aperture: 11,
        lens: lens1,
        filters: [filter1, filter3],
        location: const Location(latitude: 10, longitude: 40),
      );
      emptyFilters = Photo(
        id: 'photo-1',
        frameNumber: 1,
        recorded: DateTime(2020, 1, 2, 3, 4, 5),
        shutterSpeed: 1 / 125,
        aperture: 11,
        lens: lens1,
        filters: [],
        location: const Location(latitude: 10, longitude: 40),
      );
      reOrderedFilters = Photo(
        id: 'photo-1',
        frameNumber: 1,
        recorded: DateTime(2020, 1, 2, 3, 4, 5),
        shutterSpeed: 1 / 125,
        aperture: 11,
        lens: lens1,
        filters: [filter2, filter1],
        location: const Location(latitude: 10, longitude: 40),
      );
      otherLocation = Photo(
        id: 'photo-1',
        frameNumber: 1,
        recorded: DateTime(2020, 1, 2, 3, 4, 5),
        shutterSpeed: 1 / 125,
        aperture: 11,
        lens: lens1,
        filters: [filter1, filter2],
        location: const Location(latitude: 20, longitude: 30),
      );
      nullLocation = Photo(
        id: 'photo-1',
        frameNumber: 1,
        recorded: DateTime(2020, 1, 2, 3, 4, 5),
        shutterSpeed: 1 / 125,
        aperture: 11,
        lens: lens1,
        filters: [filter1, filter2],
        location: null,
      );
    });

    test('hashCode', () {
      expect(ref.hashCode, equals(same.hashCode));
      expect(ref.hashCode, isNot(equals(otherId.hashCode)));
      expect(ref.hashCode, isNot(equals(otherFrameNumber.hashCode)));
      expect(ref.hashCode, isNot(equals(otherRecorded.hashCode)));
      expect(ref.hashCode, isNot(equals(otherShutterSpeed.hashCode)));
      expect(ref.hashCode, isNot(equals(nullShutterSpeed.hashCode)));
      expect(ref.hashCode, isNot(equals(otherAperture.hashCode)));
      expect(ref.hashCode, isNot(equals(nullAperture.hashCode)));
      expect(ref.hashCode, isNot(equals(otherLens.hashCode)));
      expect(ref.hashCode, isNot(equals(nullLens.hashCode)));
      expect(ref.hashCode, isNot(equals(otherFilters.hashCode)));
      expect(ref.hashCode, isNot(equals(emptyFilters.hashCode)));
      expect(ref.hashCode, isNot(equals(reOrderedFilters.hashCode)));
      expect(ref.hashCode, isNot(equals(otherLocation.hashCode)));
      expect(ref.hashCode, isNot(equals(nullLocation.hashCode)));
    });

    test('==', () {
      expect(ref, equals(same));
      expect(ref, isNot(equals(otherId)));
      expect(ref, isNot(equals(otherFrameNumber)));
      expect(ref, isNot(equals(otherRecorded)));
      expect(ref, isNot(equals(otherShutterSpeed)));
      expect(ref, isNot(equals(nullShutterSpeed)));
      expect(ref, isNot(equals(otherAperture)));
      expect(ref, isNot(equals(nullAperture)));
      expect(ref, isNot(equals(otherLens)));
      expect(ref, isNot(equals(nullLens)));
      expect(ref, isNot(equals(otherFilters)));
      expect(ref, isNot(equals(emptyFilters)));
      expect(ref, isNot(equals(reOrderedFilters)));
      expect(ref, isNot(equals(otherLocation)));
      expect(ref, isNot(equals(nullLocation)));
    });
  });
}
