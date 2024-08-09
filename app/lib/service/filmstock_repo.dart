import '../model/film_stock.dart';
import 'gear_repo.dart';

class FilmstockRepo extends GearRepo<FilmStock> {
  FilmstockRepo({required super.store})
      : super(
          storageKey: 'filmstock_repo',
        );

  @override
  FilmStock itemFromJson(Map<String, dynamic> json) => FilmStock.fromJson(json);
}
