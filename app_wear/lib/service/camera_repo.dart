import 'package:film_log_wear/model/camera.dart';
import 'package:film_log_wear/service/item_repo.dart';

class CameraRepo extends ItemRepo<Camera> {
  CameraRepo._();

  static final _sharedInstance = CameraRepo._();

  factory CameraRepo() => _sharedInstance;
}
