import '../model/filter.dart';
import 'gear_repo.dart';
import 'lens_repo.dart';

class FilterRepo extends GearRepo<Filter> {
  FilterRepo({required LensRepo lensRepo, required super.store})
      : _lensRepo = lensRepo,
        super(storageKey: 'filter_repo',);

  final LensRepo _lensRepo;

  @override
  Filter itemFromJson(Map<String, dynamic> json) => Filter.fromJson(
        json,
        lenses: _lensRepo.items(),
      );
}
