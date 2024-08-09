import '../model/camera.dart';
import 'gear_repo.dart';

class CameraRepo extends GearRepo<Camera> {
  CameraRepo({required super.store})
      : super(
          storageKey: 'camera_repo',
        );

  @override
  Camera itemFromJson(Map<String, dynamic> json) => Camera.fromJson(json);
}
