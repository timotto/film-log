import 'package:film_log_wear/service/film_repo.dart';
import 'package:film_log_wear/model/photo.dart' as m;

import 'package:film_log_wear_data/model/camera.dart';
import 'package:film_log_wear_data/model/film.dart';
import 'package:film_log_wear_data/model/filter.dart';
import 'package:film_log_wear_data/model/lens.dart';
import 'package:film_log_wear_data/model/photo.dart';
import 'package:film_log_wear_data/model/state.dart';

State fakeState() => State(
      films: [
        Film(
          id: 'f1',
          name: 'Demo',
          inserted: DateTime.timestamp(),
          cameraId: 'c1',
          photos: [
            Photo(
              id: 'p1',
              recorded: DateTime.timestamp(),
              frameNumber: 1,
              shutterSpeed: 1 / 125,
              aperture: 8,
              lensId: 'l1',
              filterIdList: ['f1'],
              location: null,
            ),
          ],
          maxPhotoCount: 10,
          lensIdList: ['l1', 'l2'],
        ),
        Film(
          id: 'f2',
          name: 'Editing',
          inserted: DateTime.timestamp(),
          cameraId: 'c1',
          photos: [],
          maxPhotoCount: 10,
          lensIdList: ['l1'],
        ),
      ],
      filters: [
        const Filter(id: 'f1', label: 'Red', lensIdList: ['l1']),
        const Filter(id: 'f2', label: 'Orange', lensIdList: ['l1']),
        const Filter(id: 'f3', label: 'Yellow', lensIdList: ['l1']),
        const Filter(id: 'f4', label: 'IR', lensIdList: ['l1']),
        const Filter(id: 'f5', label: 'CPOL', lensIdList: ['l1']),
        const Filter(id: 'f6', label: 'CPOL', lensIdList: ['l2']),
      ],
      lenses: [
        const Lens(
          id: 'l1',
          label: '90mm',
          apertures: [2.8, 4, 5.6, 8, 11, 16, 22],
          cameraIds: ['c1'],
        ),
        const Lens(
          id: 'l2',
          label: '300mm',
          apertures: [4, 5.6, 8, 11, 16, 22],
          cameraIds: ['c1'],
        ),
      ],
      cameras: [
        const Camera(
          id: 'c1',
          label: '6x7',
          shutterSpeeds: [
            1 / 1000,
            1 / 500,
            1 / 250,
            1 / 125,
            1 / 60,
            1 / 30,
            1 / 15,
            1
          ],
        ),
      ],
    );

Future<void> fakeEditFilm({
  required FilmRepo repo,
  String filmId = 'f2',
}) async {
  wait() async => await Future.delayed(const Duration(seconds: 3));

  run() async {
    final film = repo.item(filmId);
    if (film == null) return false;
    if (!film.canAddPhoto()) return false;
    final frameNumber = film.photos.length;

    final updated = film.addPhoto(
      m.Photo(
        id: '',
        recorded: DateTime.timestamp(),
        frameNumber: frameNumber,
        shutterSpeed: 1/250,
        aperture: 8,
        lens: null,
        filters: [],
        location: null,
      ),
    );
    repo.update(updated);
    return true;
  }

  while (true) {
    await wait();
    final ok = await run();
    if (!ok) break;
  }
}
