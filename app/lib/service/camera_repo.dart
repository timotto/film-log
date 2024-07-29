import 'package:film_log/model/camera.dart';
import 'package:film_log/service/gear_repo.dart';

class CameraRepo extends GearRepo<Camera> {
  CameraRepo() : super(storageKey: 'camera_repo');

  @override
  Camera itemFromJson(Map<String, dynamic> json) => Camera.fromJson(json);
}
