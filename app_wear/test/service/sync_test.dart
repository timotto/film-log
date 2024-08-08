import 'package:film_log_wear/model/camera.dart';
import 'package:film_log_wear/model/film.dart';
import 'package:film_log_wear/model/filmstock.dart';
import 'package:film_log_wear/model/filter.dart';
import 'package:film_log_wear/model/lens.dart';
import 'package:film_log_wear/model/location.dart';
import 'package:film_log_wear/model/photo.dart';
import 'package:film_log_wear/service/camera_repo.dart';
import 'package:film_log_wear/service/film_repo.dart';
import 'package:film_log_wear/service/filmstock_repo.dart';
import 'package:film_log_wear/service/filter_repo.dart';
import 'package:film_log_wear/service/lens_repo.dart';
import 'package:film_log_wear/service/sync.dart';
import 'package:film_log_wear/service/wear/encode.dart';
import 'package:film_log_wear_data/model/add_photo.dart';
import 'package:film_log_wear_data/model/camera.dart' as w;
import 'package:film_log_wear_data/model/film.dart' as w;
import 'package:film_log_wear_data/model/film_stock.dart' as w;
import 'package:film_log_wear_data/model/filter.dart' as w;
import 'package:film_log_wear_data/model/lens.dart' as w;
import 'package:film_log_wear_data/model/pending.dart';
import 'package:film_log_wear_data/model/state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SyncService', () {
    late SyncService uut;
    late FilmRepo filmRepo;
    late CameraRepo cameraRepo;
    late FilterRepo filterRepo;
    late LensRepo lensRepo;
    late FilmStockRepo filmStockRepo;

    late int publishPendingCallCount;
    late List<Pending> publishPendingArguments;

    publishPending(Pending value) async {
      publishPendingCallCount++;
      publishPendingArguments.add(value);
    }

    setUp(() {
      filmRepo = FilmRepo();
      cameraRepo = CameraRepo();
      filterRepo = FilterRepo();
      lensRepo = LensRepo();
      filmStockRepo = FilmStockRepo();
      filmRepo.set([]);
      cameraRepo.set([]);
      filterRepo.set([]);
      lensRepo.set([]);
      filmStockRepo.set([]);

      publishPendingCallCount = 0;
      publishPendingArguments = [];

      uut = SyncService(
        filmRepo: filmRepo,
        cameraRepo: cameraRepo,
        filterRepo: filterRepo,
        lensRepo: lensRepo,
        filmStockRepo: filmStockRepo,
        publishPending: publishPending,
      );
    });

    group('importState', () {
      late State givenState;
      late Camera expectedCamera1, expectedCamera2;
      late Lens expectedLens1, expectedLens2;
      late Filter expectedFilter1, expectedFilter2;
      late Film expectedFilm1, expectedFilm2;
      late FilmStock expectedFilmStock1, expectedFilmStock2;

      setUp(() {
        expectedCamera1 = const Camera(
          id: 'cam-1',
          label: 'Camera 1',
          shutterSpeeds: [1 / 1000, 1 / 500, 1 / 250],
          defaultFramesPerFilm: 36,
        );
        expectedCamera2 = const Camera(
          id: 'cam-2',
          label: 'Camera 2',
          shutterSpeeds: [1 / 125, 1 / 60, 1 / 30],
          defaultFramesPerFilm: 24,
        );

        expectedLens1 = Lens(
          id: 'lens-1',
          label: 'Lens 1',
          apertures: [2.8, 5.6, 8],
          cameras: [expectedCamera1, expectedCamera2],
        );
        expectedLens2 = Lens(
          id: 'lens-2',
          label: 'Lens 2',
          apertures: [2.8, 5.6, 8, 11],
          cameras: [expectedCamera1],
        );

        expectedFilter1 = Filter(
          id: 'filter-1',
          label: 'Filter 1',
          lenses: [expectedLens1, expectedLens2],
        );
        expectedFilter2 = Filter(
          id: 'filter-2',
          label: 'Filter 2',
          lenses: [expectedLens1],
        );

        expectedFilm1 = Film(
          id: 'film-1',
          label: 'Film 1',
          inserted: DateTime(2020, 10, 5, 13, 30, 0),
          maxPhotoCount: 12,
          camera: expectedCamera1,
          actualIso: 200,
          filmStockId: 'fs-1',
          photos: [
            Photo(
              id: 'photo-1',
              frameNumber: 1,
              recorded: DateTime(2020, 10, 5, 13, 35, 0),
              shutterSpeed: 1 / 500,
              aperture: 4,
              lens: expectedLens1,
              filters: [expectedFilter1],
              location: const Location(
                latitude: 10.1345,
                longitude: 40.5432,
              ),
            ),
          ],
        );
        expectedFilm2 = Film(
          id: 'film-2',
          label: 'Film 2',
          inserted: DateTime(2020, 11, 5, 13, 30, 0),
          maxPhotoCount: 36,
          camera: expectedCamera2,
          actualIso: 200,
          filmStockId: 'fs-1',
          photos: [
            Photo(
              id: 'photo-2',
              frameNumber: 1,
              recorded: DateTime(2020, 11, 5, 13, 35, 0),
              shutterSpeed: 1 / 250,
              aperture: 4,
              lens: expectedLens2,
              filters: [expectedFilter2],
              location: const Location(
                latitude: 11.1345,
                longitude: 41.5432,
              ),
            ),
            Photo(
              id: 'photo-3',
              frameNumber: 2,
              recorded: DateTime(2020, 11, 5, 13, 40, 0),
              shutterSpeed: 1 / 125,
              aperture: 8,
              lens: expectedLens2,
              filters: [],
              location: null,
            ),
          ],
        );

        expectedFilmStock1 = FilmStock(
          id: 'fs-1',
          label: 'Film Stock 1',
          iso: 100,
          cameras: [expectedCamera1, expectedCamera2],
        );
        expectedFilmStock2 = FilmStock(
          id: 'fs-2',
          label: 'Film Stock 2',
          iso: 400,
          cameras: [expectedCamera2],
        );

        givenState = State(cameras: [
          w.Camera(
            id: expectedCamera1.id,
            label: expectedCamera1.label,
            shutterSpeeds: [...expectedCamera1.shutterSpeeds],
            defaultFramesPerFilm: expectedCamera1.defaultFramesPerFilm,
          ),
          w.Camera(
            id: expectedCamera2.id,
            label: expectedCamera2.label,
            shutterSpeeds: [...expectedCamera2.shutterSpeeds],
            defaultFramesPerFilm: expectedCamera2.defaultFramesPerFilm,
          ),
        ], lenses: [
          w.Lens(
            id: expectedLens1.id,
            label: expectedLens1.label,
            cameraIds: expectedLens1.cameras.map((c) => c.id).toList(
                  growable: false,
                ),
            apertures: [...expectedLens1.apertures],
          ),
          w.Lens(
            id: expectedLens2.id,
            label: expectedLens2.label,
            cameraIds: expectedLens2.cameras.map((c) => c.id).toList(
                  growable: false,
                ),
            apertures: [...expectedLens2.apertures],
          ),
        ], filters: [
          w.Filter(
            id: expectedFilter1.id,
            label: expectedFilter1.label,
            lensIdList: expectedFilter1.lenses.map((l) => l.id).toList(
                  growable: false,
                ),
          ),
          w.Filter(
            id: expectedFilter2.id,
            label: expectedFilter2.label,
            lensIdList: expectedFilter2.lenses.map((l) => l.id).toList(
                  growable: false,
                ),
          ),
        ], films: [
          w.Film(
            id: expectedFilm1.id,
            name: expectedFilm1.label,
            inserted: expectedFilm1.inserted,
            actualIso: expectedFilm1.actualIso,
            maxPhotoCount: expectedFilm1.maxPhotoCount,
            cameraId: expectedFilm1.camera?.id,
            filmStockId: expectedFilm1.filmStockId,
            lensIdList: [expectedLens1.id, expectedLens2.id],
            photos: expectedFilm1.photos.map(encodePhoto).toList(
                  growable: false,
                ),
          ),
          w.Film(
            id: expectedFilm2.id,
            name: expectedFilm2.label,
            inserted: expectedFilm2.inserted,
            maxPhotoCount: expectedFilm2.maxPhotoCount,
            cameraId: expectedFilm2.camera?.id,
            lensIdList: [expectedLens1.id],
            actualIso: expectedFilm2.actualIso,
            filmStockId: expectedFilm2.filmStockId,
            photos: expectedFilm2.photos.map(encodePhoto).toList(
                  growable: false,
                ),
          ),
        ], filmStocks: [
          w.FilmStock(
            id: expectedFilmStock1.id,
            label: expectedFilmStock1.label,
            iso: expectedFilmStock1.iso,
            cameraIds: expectedFilmStock1.cameras.map((c) => c.id).toList(
                  growable: false,
                ),
          ),
          w.FilmStock(
            id: expectedFilmStock2.id,
            label: expectedFilmStock2.label,
            iso: expectedFilmStock2.iso,
            cameraIds: expectedFilmStock2.cameras.map((c) => c.id).toList(
                  growable: false,
                ),
          ),
        ]);
      });

      group('repo update', () {
        test('stores cameras', () async {
          await uut.importState(givenState);

          expect(
            cameraRepo.value(),
            containsAll([
              expectedCamera1,
              expectedCamera2,
            ]),
          );
        });

        test('stores lenses', () async {
          await uut.importState(givenState);

          expect(
            lensRepo.value(),
            containsAll([
              expectedLens1,
              expectedLens2,
            ]),
          );
        });

        test('stores filters', () async {
          await uut.importState(givenState);

          expect(
            filterRepo.value(),
            containsAll([
              expectedFilter1,
              expectedFilter2,
            ]),
          );
        });

        test('stores films', () async {
          await uut.importState(givenState);

          expect(
            filmRepo.value(),
            containsAll([
              expectedFilm1,
              expectedFilm2,
            ]),
          );
        });

        test('stores film stocks', () async {
          await uut.importState(givenState);

          expect(
            filmStockRepo.value(),
            containsAll([
              expectedFilmStock1,
              expectedFilmStock2,
            ]),
          );
        });
      });

      group('Pending', () {
        test('removes Pending Photos when found in State', () async {
          await uut.addPhoto(
            photo: Photo(
              id: 'photo-1',
              frameNumber: 1,
              recorded: DateTime(2020, 10, 5, 13, 35, 0),
              shutterSpeed: 1 / 500,
              aperture: 4,
              lens: expectedLens1,
              filters: [expectedFilter1],
              location: const Location(
                latitude: 10.1345,
                longitude: 40.5432,
              ),
            ),
            filmId: 'film-1',
          );
          final expectedRemainingPhoto = Photo(
            id: 'photo-9',
            frameNumber: 1,
            recorded: DateTime(2020, 10, 5, 13, 35, 0),
            shutterSpeed: 1 / 125,
            aperture: 8,
            lens: expectedLens1,
            filters: [expectedFilter1],
            location: const Location(
              latitude: 10.1345,
              longitude: 40.5432,
            ),
          );
          await uut.addPhoto(
            photo: expectedRemainingPhoto,
            filmId: 'film-2',
          );

          await uut.importState(givenState);

          final actualResult = publishPendingArguments.last.addPhotos;
          expect(actualResult.length, equals(1));
          expect(
            actualResult.last,
            equals(AddPhoto(
              filmId: 'film-2',
              photo: encodePhoto(expectedRemainingPhoto),
            )),
          );
        });

        test('removes Pending Films when found in State', () async {
          final addedFilmGivenInState = Film(
            id: 'film-1',
            label: 'Film 1',
            inserted: DateTime(2020),
            maxPhotoCount: 10,
            camera: null,
            actualIso: 200,
            filmStockId: 'fs-1',
            photos: [],
          );
          final addedFilmExpectedToRemain = Film(
            id: 'film-2',
            label: 'Film 2',
            inserted: DateTime(2020, 1, 2),
            maxPhotoCount: 12,
            camera: null,
            actualIso: 200,
            filmStockId: 'fs-1',
            photos: [],
          );

          await uut.addFilm(addedFilmExpectedToRemain);
          await uut.addFilm(addedFilmGivenInState);

          await uut.importState(State(
            films: [encodeFilm(addedFilmGivenInState, lenses: [])],
            filters: [],
            lenses: [],
            cameras: [],
            filmStocks: [],
          ));

          final actualResult = publishPendingArguments.last.addFilms;
          expect(
              actualResult,
              contains(encodeFilm(
                addedFilmExpectedToRemain,
                lenses: [],
              )));
          expect(
              actualResult,
              isNot(contains(encodeFilm(
                addedFilmGivenInState,
                lenses: [],
              ))));
        });

        test('does not call publishPending when nothing changes', () async {
          await uut.importState(givenState);

          expect(publishPendingCallCount, equals(0));
        });
      });
    });

    group('addPhoto', () {
      test('calls publishPending callback', () async {
        final givenPhoto = Photo(
          id: 'photo-1',
          frameNumber: 1,
          recorded: DateTime(2020, 1, 2, 3, 4, 5),
          shutterSpeed: 1 / 125,
          aperture: 8,
          lens: null,
          filters: [],
          location: const Location(latitude: 10.123, longitude: 40.543),
        );

        await uut.addPhoto(photo: givenPhoto, filmId: 'film-1');

        expect(publishPendingCallCount, equals(1));
        expect(publishPendingArguments.length, equals(1));
        final arg = publishPendingArguments[0];
        expect(arg.addPhotos.length, equals(1));
        expect(
            arg.addPhotos[0],
            equals(AddPhoto(
              filmId: 'film-1',
              photo: encodePhoto(givenPhoto),
            )));
      });

      test('collects updates', () async {
        final givenPhoto1 = Photo(
          id: 'photo-1',
          frameNumber: 1,
          recorded: DateTime(2020, 1, 2, 3, 4, 5),
          shutterSpeed: 1 / 125,
          aperture: 8,
          lens: null,
          filters: [],
          location: const Location(latitude: 10.123, longitude: 40.543),
        );
        final givenPhoto2 = Photo(
          id: 'photo-2',
          frameNumber: 2,
          recorded: DateTime(2020, 1, 2, 3, 10, 5),
          shutterSpeed: 1 / 250,
          aperture: 5.6,
          lens: null,
          filters: [],
          location: null,
        );
        final givenPhoto3 = Photo(
          id: 'photo-3',
          frameNumber: 1,
          recorded: DateTime(2020, 1, 2, 3, 10, 5),
          shutterSpeed: 1 / 250,
          aperture: 5.6,
          lens: null,
          filters: [],
          location: null,
        );

        await uut.addPhoto(photo: givenPhoto1, filmId: 'film-1');
        await uut.addPhoto(photo: givenPhoto2, filmId: 'film-1');
        await uut.addPhoto(photo: givenPhoto3, filmId: 'film-2');

        expect(
            publishPendingArguments.last.addPhotos,
            containsAll([
              AddPhoto(filmId: 'film-1', photo: encodePhoto(givenPhoto1)),
              AddPhoto(filmId: 'film-1', photo: encodePhoto(givenPhoto2)),
              AddPhoto(filmId: 'film-2', photo: encodePhoto(givenPhoto3)),
            ]));
      });

      test('updates FilmRepo', () async {
        await uut.importState(State(
          films: [
            w.Film(
              id: 'film-1',
              name: 'Film 1',
              inserted: DateTime(2000),
              maxPhotoCount: 10,
              photos: [],
              lensIdList: [],
              cameraId: null,
              actualIso: 200,
              filmStockId: 'fs-1',
            ),
          ],
          filters: [],
          lenses: [],
          cameras: [],
          filmStocks: [],
        ));

        final givenPhoto = Photo(
          id: 'photo-1',
          frameNumber: 1,
          recorded: DateTime(2021),
          shutterSpeed: 1 / 250,
          aperture: 5.6,
          lens: null,
          filters: [],
          location: null,
        );

        await uut.addPhoto(
          photo: givenPhoto,
          filmId: 'film-1',
        );

        expect(filmRepo.value().length, equals(1));
        expect(filmRepo.value().last.photos.length, equals(1));
        expect(filmRepo.value().last.photos.last, equals(givenPhoto));
      });
    });

    group('addFilm', () {
      test('calls publishPending callback', () async {
        final givenFilm = Film(
          id: 'film-9',
          label: 'Wear OS Film',
          inserted: DateTime(2020, 1, 2),
          maxPhotoCount: 12,
          camera: null,
          photos: [],
          actualIso: 200,
          filmStockId: 'fs-1',
        );

        await uut.addFilm(givenFilm);

        expect(publishPendingCallCount, equals(1));
        expect(publishPendingArguments.length, equals(1));
        final arg = publishPendingArguments[0];
        expect(arg.addFilms.length, equals(1));
        expect(arg.addFilms[0], equals(encodeFilm(givenFilm, lenses: [])));
      });

      test('updates FilmRepo', () async {
        final givenFilm = Film(
          id: 'film-9',
          label: 'Wear OS Film',
          inserted: DateTime(2020, 1, 2),
          maxPhotoCount: 12,
          camera: null,
          photos: [],
          actualIso: 200,
          filmStockId: 'fs-1',
        );

        await uut.addFilm(givenFilm);

        expect(filmRepo.value(), contains(givenFilm));
      });
    });

    group('set pending', () {
      group('when there is State', () {
        setUp(() async {
          await uut.importState(State(
            films: [
              w.Film(
                id: 'film-1',
                name: 'Film 1',
                inserted: DateTime(2000),
                maxPhotoCount: 10,
                photos: [],
                lensIdList: [],
                cameraId: null,
                actualIso: 200,
                filmStockId: 'fs-1',
              ),
            ],
            filters: [],
            lenses: [],
            cameras: [],
            filmStocks: [],
          ));
        });

        test('adds Photo to FilmRepo', () async {
          final givenPhoto = Photo(
            id: 'photo-1',
            frameNumber: 1,
            recorded: DateTime(2021),
            shutterSpeed: 1 / 250,
            aperture: 11,
            lens: null,
            filters: [],
            location: null,
          );

          uut.pending = Pending(
            addPhotos: [
              AddPhoto(filmId: 'film-1', photo: encodePhoto(givenPhoto)),
            ],
            addFilms: [],
          );

          expect(filmRepo.value().length, equals(1));
          expect(filmRepo.value().last.photos.length, equals(1));
          expect(filmRepo.value().last.photos.last, equals(givenPhoto));
        });

        test('adds Film to FilmRepo', () async {
          final givenFilm = Film(
            id: 'film-9',
            label: 'Wear OS Film',
            inserted: DateTime(2020, 1, 2),
            maxPhotoCount: 12,
            camera: null,
            photos: [],
            actualIso: 200,
            filmStockId: 'fs-1',
          );

          uut.pending = Pending(
            addPhotos: [],
            addFilms: [encodeFilm(givenFilm, lenses: [])],
          );

          expect(filmRepo.value(), contains(givenFilm));
        });

        test('does not remove photos of existing film', () async {
          final existingPhoto = Photo(
            id: 'photo-1',
            frameNumber: 1,
            recorded: DateTime(2021),
            filters: [],
            shutterSpeed: 1 / 250,
            aperture: 4,
            lens: null,
            location: null,
          );

          final existingFilm = w.Film(
            id: 'film-1',
            name: 'Film 1',
            inserted: DateTime(2000),
            maxPhotoCount: 10,
            photos: [encodePhoto(existingPhoto)],
            lensIdList: [],
            cameraId: null,
            actualIso: 200,
            filmStockId: 'fs-1',
          );

          await uut.importState(State(
            films: [existingFilm],
            filters: [],
            lenses: [],
            cameras: [],
            filmStocks: [],
          ));

          final givenFilm = Film(
            id: existingFilm.id,
            label: 'Wear OS Film',
            inserted: DateTime(2020, 1, 2),
            maxPhotoCount: 12,
            camera: null,
            photos: [],
            actualIso: 200,
            filmStockId: 'fs-1',
          );

          uut.pending = Pending(
            addPhotos: [],
            addFilms: [encodeFilm(givenFilm, lenses: [])],
          );

          expect(filmRepo.value().length, equals(1));
          final actualFilm = filmRepo.value()[0];
          expect(actualFilm.id, equals(existingFilm.id));
          expect(actualFilm.photos, contains(existingPhoto));
        });
      });

      group('when there is no State', () {
        test('adds Photo to FilmRepo and also adds matching Film', () async {
          expect(filmRepo.value().length, equals(0));

          final givenPhoto = Photo(
            id: 'photo-1',
            frameNumber: 1,
            recorded: DateTime(2021),
            shutterSpeed: 1 / 250,
            aperture: 16,
            lens: null,
            filters: [],
            location: null,
          );

          uut.pending = Pending(
            addPhotos: [
              AddPhoto(filmId: 'film-1', photo: encodePhoto(givenPhoto)),
            ],
            addFilms: [],
          );

          expect(filmRepo.value().length, equals(1));
          expect(filmRepo.value().last.photos.length, equals(1));
          expect(filmRepo.value().last.photos.last, equals(givenPhoto));
        });
      });
    });
  });
}
