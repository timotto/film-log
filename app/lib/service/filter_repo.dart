import 'package:film_log/service/lens_repo.dart';

import '../model/filter.dart';
import 'gear_repo.dart';

class FilterRepo extends GearRepo<Filter> {
  FilterRepo({required LensRepo lensRepo})
      : _lensRepo = lensRepo,
        super(storageKey: 'filter_repo') {
    // updateItems([
    //   Filter(
    //       id: '1',
    //       name: 'Red',
    //       manufacturer: 'Something',
    //       product: 'Dark Red',
    //       lenses: lensRepo
    //           .items()
    //           .where((item) => item.id == "1")
    //           .toList(growable: false)),
    // ]);
  }

  final LensRepo _lensRepo;

  @override
  Filter itemFromJson(Map<String, dynamic> json) => Filter.fromJson(
        json,
        lenses: _lensRepo.items(),
      );
}
