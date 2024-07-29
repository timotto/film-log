import 'package:film_log/model/lens.dart';
import 'package:film_log/service/camera_repo.dart';
import 'package:film_log/service/gear_repo.dart';

class LensRepo extends GearRepo<Lens> {
  LensRepo({required CameraRepo cameraRepo})
      : _cameraRepo = cameraRepo,
        super(storageKey: 'lens_repo');

  final CameraRepo _cameraRepo;

  @override
  Lens itemFromJson(Map<String, dynamic> json) => Lens.fromJson(
        json,
        cameras: _cameraRepo.items(),
      );
}
