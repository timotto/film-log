import 'package:film_log_wear/service/item_repo.dart';

import '../model/filter.dart';

class FilterRepo extends ItemRepo<Filter> {
  FilterRepo._();

  static final _sharedInstance = FilterRepo._();

  factory FilterRepo() => _sharedInstance;
}
