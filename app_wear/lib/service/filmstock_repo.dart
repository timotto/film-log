import '../model/filmstock.dart';
import 'item_repo.dart';

class FilmStockRepo extends ItemRepo<FilmStock> {
  FilmStockRepo._();

  static final _sharedInstance = FilmStockRepo._();

  factory FilmStockRepo() => _sharedInstance;
}
