import 'package:film_log/model/fstop.dart';
import 'package:film_log/model/lens.dart';
import 'package:film_log/service/camera_repo.dart';
import 'package:film_log/service/gear_repo.dart';

class LensRepo extends GearRepo<Lens> {
  LensRepo({required CameraRepo cameraRepo})
      : _cameraRepo = cameraRepo,
        super(storageKey: 'lens_repo') {
    // updateItems([
    //   Lens(
    //     id: '1',
    //     name: '90mm',
    //     manufacturer: 'Pentax',
    //     product: 'SMC 90mm',
    //     cameras: [cameraRepo.items().where((c) => c.id == '1').first],
    //     type: LensType.prime,
    //     focalLengthMin: 90,
    //     focalLengthMax: 90,
    //     fStopIncrements: FStopIncrements.half,
    //     apertureMin: 2.8,
    //     apertureMax: 22,
    //   ),
    // ]);
  }

  final CameraRepo _cameraRepo;

  @override
  Lens itemFromJson(Map<String, dynamic> json) => Lens.fromJson(
        json,
        cameras: _cameraRepo.items(),
      );
}
