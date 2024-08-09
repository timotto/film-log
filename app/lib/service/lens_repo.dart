import '../model/lens.dart';
import 'camera_repo.dart';
import 'gear_repo.dart';

class LensRepo extends GearRepo<Lens> {
  LensRepo({required CameraRepo cameraRepo, required super.store})
      : _cameraRepo = cameraRepo,
        super(storageKey: 'lens_repo');

  final CameraRepo _cameraRepo;

  @override
  Lens itemFromJson(Map<String, dynamic> json) => Lens.fromJson(
        json,
        cameras: _cameraRepo.items(),
      );
}
