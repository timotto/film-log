import 'package:film_log_wear/service/item_repo.dart';

import '../model/film.dart';

class FilmRepo extends ItemRepo<Film> {
  FilmRepo._();

  static final _sharedInstance = FilmRepo._();

  factory FilmRepo() => _sharedInstance;

  void what() {}
}
