import '../model/film.dart';
import 'item_repo.dart';

class FilmRepo extends ItemRepo<Film> {
  FilmRepo._();

  static final _sharedInstance = FilmRepo._();

  factory FilmRepo() => _sharedInstance;
}
