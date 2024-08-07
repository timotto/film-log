import 'package:film_log_wear/model/film.dart';
import 'package:film_log_wear/model/photo.dart';
import 'package:film_log_wear/service/camera_repo.dart';
import 'package:film_log_wear/service/film_repo.dart';
import 'package:film_log_wear/service/filter_repo.dart';
import 'package:film_log_wear/service/lens_repo.dart';
import 'package:film_log_wear/service/wear/encode.dart';
import 'package:film_log_wear_data/model/add_photo.dart';
import 'package:film_log_wear_data/model/pending.dart';
import 'package:film_log_wear_data/model/state.dart';
import 'package:logging/logging.dart';

import 'wear/decode.dart';

final _log = Logger('sync-service');

class SyncService {
  SyncService({
    required this.filmRepo,
    required this.cameraRepo,
    required this.filterRepo,
    required this.lensRepo,
    required this.publishPending,
  });

  final FilmRepo filmRepo;
  final CameraRepo cameraRepo;
  final FilterRepo filterRepo;
  final LensRepo lensRepo;

  final Future<void> Function(Pending) publishPending;

  Pending _pending = const Pending(addPhotos: []);

  set pending(Pending value) {
    _pending = value;
    _syncPendingToLocal();
  }

  Future<void> importState(State state) async {
    final cameras =
        _neverNull(state.cameras.map(decodeCamera)).toList(growable: false);

    final lenses = _neverNull(state.lenses.map((item) => decodeLens(
          item,
          cameras: cameras,
        ))).toList(growable: false);

    final filters = _neverNull(state.filters.map((item) => decodeFilter(
          item,
          lenses: lenses,
        ))).toList(growable: false);

    final films = state.films
        .map((item) => decodeFilm(
              item,
              cameras: cameras,
              filters: filters,
              lenses: lenses,
            ))
        .toList(growable: false);

    filmRepo.set(films);
    cameraRepo.set(cameras);
    filterRepo.set(filters);
    lensRepo.set(lenses);

    _log.finer(
        'import-state result: films=${films.length} cameras=${cameras.length} filters=${filters.length} lenses=${lenses.length}');

    final pending = _updatePending(state);
    if (!pending.equals(_pending)) {
      _pending = pending;
      await publishPending(_pending);
    }
  }

  Future<void> addPhoto({required Photo photo, required String filmId}) async {
    _pending = _pending.addItem(AddPhoto(
      filmId: filmId,
      photo: encodePhoto(photo),
    ));
    _syncPendingToLocal();
    await publishPending(_pending);
  }

  Pending _updatePending(State state) {
    final List<AddPhoto> missing = [];

    for (var addPhoto in _pending.addPhotos) {
      final film =
          state.films.where((film) => film.id == addPhoto.filmId).firstOrNull;
      if (film == null) {
        _log.info(
            'update-pending: add-photo with unknown film id: ${addPhoto.filmId}');
        continue;
      }

      final photo = film.photos
          .where((photo) => photo.id == addPhoto.photo.id)
          .firstOrNull;

      if (photo == null) {
        missing.add(addPhoto);
        continue;
      }
    }

    return Pending(addPhotos: missing);
  }

  void _syncPendingToLocal() {
    final byFilm = _pending.addPhotosByFilm;
    for (var filmId in byFilm.keys) {
      var film = filmRepo.item(filmId);
      if (film == null) {
        film = Film(
          id: filmId,
          label: 'Film',
          inserted: DateTime.timestamp(),
          maxPhotoCount: 10,
          camera: null,
          photos: [],
        );
        filmRepo.update(film);
      }

      final photos = byFilm[filmId]!;
      for (var item in photos) {
        final photo = decodePhoto(
          item,
          lenses: lensRepo.value(),
          filters: filterRepo.value(),
        );
        film = film!.addPhoto(photo);
      }
      filmRepo.update(film!);
    }
  }
}

Iterable<T> _neverNull<T>(Iterable<T?> items) =>
    items.where((item) => item != null).map((item) => item!);
