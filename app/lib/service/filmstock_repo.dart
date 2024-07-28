import '../model/film_stock.dart';
import '../model/filmstock_format.dart';
import 'gear_repo.dart';

class FilmstockRepo extends GearRepo<FilmStock> {
  FilmstockRepo() : super(storageKey: 'filmstock_repo') {
    // updateItems([
    //   FilmStock(
    //     id: '1',
    //     manufacturer: 'Kodak',
    //     product: 'Gold',
    //     iso: 200,
    //     format: FilmStockFormat.type120,
    //     type: FilmStockType.color,
    //   ),
    //   FilmStock(
    //     id: '2',
    //     manufacturer: 'Kodak',
    //     product: 'Tri-X',
    //     iso: 400,
    //     format: FilmStockFormat.type120,
    //     type: FilmStockType.blackAndWhitePanchromatic,
    //   ),
    //   FilmStock(
    //     id: '3',
    //     manufacturer: 'Kodak',
    //     product: 'T-Max',
    //     iso: 400,
    //     format: FilmStockFormat.type120,
    //     type: FilmStockType.blackAndWhitePanchromatic,
    //   ),
    // ]);
  }

  @override
  FilmStock itemFromJson(Map<String, dynamic> json) => FilmStock.fromJson(json);
}
