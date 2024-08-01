import 'package:film_log_wear/service/item_repo.dart';

import '../model/lens.dart';

class LensRepo extends ItemRepo<Lens> {
  LensRepo._();

  static final _sharedInstance = LensRepo._();

  factory LensRepo() => _sharedInstance;
}
