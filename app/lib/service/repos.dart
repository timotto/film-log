import 'package:film_log/service/film_repo.dart';

import 'camera_repo.dart';
import 'filmstock_repo.dart';
import 'filter_repo.dart';
import 'lens_repo.dart';

class Repos {
  Repos._() {
    lensRepo = LensRepo(cameraRepo: cameraRepo);
    filterRepo = FilterRepo(lensRepo: lensRepo);
  }

  static final _sharedInstance = Repos._();

  factory Repos() => _sharedInstance;

  final cameraRepo = CameraRepo();
  late final LensRepo lensRepo;
  late final FilterRepo filterRepo;
  final filmstockRepo = FilmstockRepo();
  final filmRepo = FilmRepo();

  Future<void> load() async {
    try {
      print('repos::load');
      await Future.wait([
            cameraRepo.load(),
            filmstockRepo.load(),
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
}
