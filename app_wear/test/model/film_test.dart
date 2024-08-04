import 'package:film_log_wear/model/camera.dart';
import 'package:film_log_wear/model/film.dart';
import 'package:film_log_wear/model/filter.dart';
import 'package:film_log_wear/model/lens.dart';
import 'package:film_log_wear/model/location.dart';
import 'package:film_log_wear/model/photo.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Film', () {
    late Film ref;
    late Film same;
    late Film otherId,
        otherLabel,
        otherInserted,
        otherMaxPhotoCount,
        otherCamera,
        nullCamera,
        otherPhotos,
        reOrderedPhotos;

    late Camera camera1, camera2;
    late Lens lens1, lens2;
    late Filter filter1;

    setUp(() {
      camera1 = const Camera(
        id: 'cam-1',
        label: 'Camera 1',
        shutterSpeeds: [1 / 1000, 1 / 500, 1 / 250],
      );
      camera2 = const Camera(
        id: 'cam-2',
        label: 'Camera 2',
        shutterSpeeds: [1 / 1000, 1 / 500, 1 / 250],
      );

      lens1 = Lens(
        id: 'lens-1',
        label: 'Lens 1',
        apertures: [2.8, 5.6, 8],
        cameras: [camera1],
      );
      lens2 = Lens(
        id: 'lens-2',
        label: 'Lens 2',
        apertures: [2.8, 5.6, 8, 11, 16],
        cameras: [camera2],
      );
      filter1 = Filter(
        id: 'filter-1',
        label: 'Filter 1',
        lenses: [lens1, lens2],
      );

      ref = Film(
        id: 'film-1',
        label: 'Film 1',
        inserted: DateTime(2020, 1, 2, 3, 4, 5),
        maxPhotoCount: 24,
        camera: camera1,
        photos: [
          Photo(
            id: 'photo-1',
            frameNumber: 1,
            recorded: DateTime(2020, 1, 2, 3, 5),
            shutterSpeed: 1 / 500,
            aperture: 5.6,
            lens: lens1,
            filters: [filter1],
            location: const Location(latitude: 10, longitude: 40),
          ),
          Photo(
            id: 'photo-2',
            frameNumber: 2,
            recorded: DateTime(2020, 1, 2, 3, 6),
            shutterSpeed: 1 / 250,
            aperture: 8,
            lens: lens2,
            filters: [],
            location: null,
          ),
        ],
      );

      same = Film(
        id: 'film-1',
        label: 'Film 1',
        inserted: DateTime(2020, 1, 2, 3, 4, 5),
        maxPhotoCount: 24,
        camera: camera1,
        photos: [
          Photo(
            id: 'photo-1',
            frameNumber: 1,
            recorded: DateTime(2020, 1, 2, 3, 5),
            shutterSpeed: 1 / 500,
            aperture: 5.6,
            lens: lens1,
            filters: [filter1],
            location: const Location(latitude: 10, longitude: 40),
          ),
          Photo(
            id: 'photo-2',
            frameNumber: 2,
            recorded: DateTime(2020, 1, 2, 3, 6),
            shutterSpeed: 1 / 250,
            aperture: 8,
            lens: lens2,
            filters: [],
            location: null,
          ),
        ],
      );

      otherId = Film(
        id: 'film-2',
        label: 'Film 1',
        inserted: DateTime(2020, 1, 2, 3, 4, 5),
        maxPhotoCount: 24,
        camera: camera1,
        photos: [
          Photo(
            id: 'photo-1',
            frameNumber: 1,
            recorded: DateTime(2020, 1, 2, 3, 5),
            shutterSpeed: 1 / 500,
            aperture: 5.6,
            lens: lens1,
            filters: [filter1],
            location: const Location(latitude: 10, longitude: 40),
          ),
          Photo(
            id: 'photo-2',
            frameNumber: 2,
            recorded: DateTime(2020, 1, 2, 3, 6),
            shutterSpeed: 1 / 250,
            aperture: 8,
            lens: lens2,
            filters: [],
            location: null,
          ),
        ],
      );

      otherLabel = Film(
        id: 'film-1',
        label: 'Film 2',
        inserted: DateTime(2020, 1, 2, 3, 4, 5),
        maxPhotoCount: 24,
        camera: camera1,
        photos: [
          Photo(
            id: 'photo-1',
            frameNumber: 1,
            recorded: DateTime(2020, 1, 2, 3, 5),
            shutterSpeed: 1 / 500,
            aperture: 5.6,
            lens: lens1,
            filters: [filter1],
            location: const Location(latitude: 10, longitude: 40),
          ),
          Photo(
            id: 'photo-2',
            frameNumber: 2,
            recorded: DateTime(2020, 1, 2, 3, 6),
            shutterSpeed: 1 / 250,
            aperture: 8,
            lens: lens2,
            filters: [],
            location: null,
          ),
        ],
      );

      otherInserted = Film(
        id: 'film-1',
        label: 'Film 1',
        inserted: DateTime(2022, 1, 2, 3, 4, 5),
        maxPhotoCount: 24,
        camera: camera1,
        photos: [
          Photo(
            id: 'photo-1',
            frameNumber: 1,
            recorded: DateTime(2020, 1, 2, 3, 5),
            shutterSpeed: 1 / 500,
            aperture: 5.6,
            lens: lens1,
            filters: [filter1],
            location: const Location(latitude: 10, longitude: 40),
          ),
          Photo(
            id: 'photo-2',
            frameNumber: 2,
            recorded: DateTime(2020, 1, 2, 3, 6),
            shutterSpeed: 1 / 250,
            aperture: 8,
            lens: lens2,
            filters: [],
            location: null,
          ),
        ],
      );

      otherMaxPhotoCount = Film(
        id: 'film-1',
        label: 'Film 1',
        inserted: DateTime(2020, 1, 2, 3, 4, 5),
        maxPhotoCount: 36,
        camera: camera1,
        photos: [
          Photo(
            id: 'photo-1',
            frameNumber: 1,
            recorded: DateTime(2020, 1, 2, 3, 5),
            shutterSpeed: 1 / 500,
            aperture: 5.6,
            lens: lens1,
            filters: [filter1],
            location: const Location(latitude: 10, longitude: 40),
          ),
          Photo(
            id: 'photo-2',
            frameNumber: 2,
            recorded: DateTime(2020, 1, 2, 3, 6),
            shutterSpeed: 1 / 250,
            aperture: 8,
            lens: lens2,
            filters: [],
            location: null,
          ),
        ],
      );

      otherCamera = Film(
        id: 'film-1',
        label: 'Film 1',
        inserted: DateTime(2020, 1, 2, 3, 4, 5),
        maxPhotoCount: 24,
        camera: camera2,
        photos: [
          Photo(
            id: 'photo-1',
            frameNumber: 1,
            recorded: DateTime(2020, 1, 2, 3, 5),
            shutterSpeed: 1 / 500,
            aperture: 5.6,
            lens: lens1,
            filters: [filter1],
            location: const Location(latitude: 10, longitude: 40),
          ),
          Photo(
            id: 'photo-2',
            frameNumber: 2,
            recorded: DateTime(2020, 1, 2, 3, 6),
            shutterSpeed: 1 / 250,
            aperture: 8,
            lens: lens2,
            filters: [],
            location: null,
          ),
        ],
      );

      nullCamera = Film(
        id: 'film-1',
        label: 'Film 1',
        inserted: DateTime(2020, 1, 2, 3, 4, 5),
        maxPhotoCount: 24,
        camera: null,
        photos: [
          Photo(
            id: 'photo-1',
            frameNumber: 1,
            recorded: DateTime(2020, 1, 2, 3, 5),
            shutterSpeed: 1 / 500,
            aperture: 5.6,
            lens: lens1,
            filters: [filter1],
            location: const Location(latitude: 10, longitude: 40),
          ),
          Photo(
            id: 'photo-2',
            frameNumber: 2,
            recorded: DateTime(2020, 1, 2, 3, 6),
            shutterSpeed: 1 / 250,
            aperture: 8,
            lens: lens2,
            filters: [],
            location: null,
          ),
        ],
      );

      otherPhotos = Film(
        id: 'film-1',
        label: 'Film 1',
        inserted: DateTime(2020, 1, 2, 3, 4, 5),
        maxPhotoCount: 24,
        camera: camera1,
        photos: [
          Photo(
            id: 'photo-1',
            frameNumber: 1,
            recorded: DateTime(2020, 1, 2, 3, 5),
            shutterSpeed: 1 / 500,
            aperture: 5.6,
            lens: lens1,
            filters: [filter1],
            location: const Location(latitude: 10, longitude: 40),
          ),
          Photo(
            id: 'photo-3',
            frameNumber: 2,
            recorded: DateTime(2020, 1, 2, 3, 7),
            shutterSpeed: 1 / 250,
            aperture: 8,
            lens: lens2,
            filters: [],
            location: null,
          ),
        ],
      );

      reOrderedPhotos = Film(
        id: 'film-1',
        label: 'Film 1',
        inserted: DateTime(2020, 1, 2, 3, 4, 5),
        maxPhotoCount: 24,
        camera: camera1,
        photos: [
          Photo(
            id: 'photo-2',
            frameNumber: 2,
            recorded: DateTime(2020, 1, 2, 3, 6),
            shutterSpeed: 1 / 250,
            aperture: 8,
            lens: lens2,
            filters: [],
            location: null,
          ),
          Photo(
            id: 'photo-1',
            frameNumber: 1,
            recorded: DateTime(2020, 1, 2, 3, 5),
            shutterSpeed: 1 / 500,
            aperture: 5.6,
            lens: lens1,
            filters: [filter1],
            location: const Location(latitude: 10, longitude: 40),
          ),
        ],
      );
    });

    test('hashCode', () {
      expect(ref.hashCode, equals(same.hashCode));
      expect(ref.hashCode, isNot(equals(otherId.hashCode)));
      expect(ref.hashCode, isNot(equals(otherLabel.hashCode)));
      expect(ref.hashCode, isNot(equals(otherInserted.hashCode)));
      expect(ref.hashCode, isNot(equals(otherMaxPhotoCount.hashCode)));
      expect(ref.hashCode, isNot(equals(otherCamera.hashCode)));
      expect(ref.hashCode, isNot(equals(nullCamera.hashCode)));
      expect(ref.hashCode, isNot(equals(otherPhotos.hashCode)));
      expect(ref.hashCode, isNot(equals(reOrderedPhotos.hashCode)));
    });

    test('==', () {
      expect(ref, equals(same));
      expect(ref, isNot(equals(otherId)));
      expect(ref, isNot(equals(otherLabel)));
      expect(ref, isNot(equals(otherInserted)));
      expect(ref, isNot(equals(otherMaxPhotoCount)));
      expect(ref, isNot(equals(otherCamera)));
      expect(ref, isNot(equals(nullCamera)));
      expect(ref, isNot(equals(otherPhotos)));
      expect(ref, isNot(equals(reOrderedPhotos)));
    });
  });
}
