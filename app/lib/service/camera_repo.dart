import 'package:film_log/model/camera.dart';
import 'package:film_log/model/filmstock_format.dart';
import 'package:film_log/service/gear_repo.dart';

class CameraRepo extends GearRepo<Camera> {
  CameraRepo() : super(storageKey: 'camera_repo') {
    // updateItems([
    //   Camera(
    //     id: '1',
    //     name: '6x7',
    //     manufacturer: 'Pentax',
    //     product: '6x7',
    //     fastestShutterSpeed: 1/1000,
    //     slowestShutterSpeed: 1,
    //     filmstockFormat: FilmStockFormat.type120,
    //   ),
    //   Camera(
    //     id: '2',
    //     name: '127',
    //     manufacturer: 'Zeiss Ikon',
    //     product: 'Ikonta',
    //     fastestShutterSpeed: 1/1000,
    //     slowestShutterSpeed: 1,
    //     filmstockFormat: FilmStockFormat.type127,
    //   ),
    // ]);
  }

  @override
  Camera itemFromJson(Map<String, dynamic> json) => Camera.fromJson(json);
}
