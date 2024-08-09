import 'camera_repo.dart';
import 'film_repo.dart';
import 'filmstock_repo.dart';
import 'filter_repo.dart';
import 'lens_repo.dart';
import 'persistence.dart';
import 'thumbnail_repo.dart';

class Repos {
  Repos({required Persistence store}) {
    cameraRepo = CameraRepo(store: store);
    filmstockRepo = FilmstockRepo(store: store);
    filmRepo = FilmRepo(store: store);
    lensRepo = LensRepo(cameraRepo: cameraRepo, store: store);
    filterRepo = FilterRepo(lensRepo: lensRepo, store: store);
  }

  late final CameraRepo cameraRepo;
  late final LensRepo lensRepo;
  late final FilterRepo filterRepo;
  late final FilmstockRepo filmstockRepo;
  late final FilmRepo filmRepo;
  final thumbnailRepo = ThumbnailRepo();

  Future<void> load() async {
    try {
      print('repos::load');
      await Future.wait([
        cameraRepo.load(),
        filmstockRepo.load(),
        thumbnailRepo.load(),
      ]);

      await lensRepo.load();
      await filterRepo.load();

      await filmRepo.load(
        cameraRepo: cameraRepo,
        filmstockRepo: filmstockRepo,
        filterRepo: filterRepo,
        lensRepo: lensRepo,
      );
      print('repos::load - complete');
    } catch (e) {
      print('repos::load - failed $e');
    }
  }

  void addChangeListener(void Function() cb) {
    cameraRepo.addChangeListener(cb);
    lensRepo.addChangeListener(cb);
    filmRepo.addChangeListener(cb);
    filmstockRepo.addChangeListener(cb);
    filmRepo.addChangeListener(cb);
  }
}
