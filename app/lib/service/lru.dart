import 'package:film_log/model/film_stock.dart';

import '../model/camera.dart';

class LruService {
  LruService._();

  static final LruService sharedInstance = LruService._();

  factory LruService() => sharedInstance;

  Camera? _camera;
  FilmStock? _filmStock;
  int? _maxPhotoCount;

  Camera? get camera => _camera;

  FilmStock? get filmStock => _filmStock;

  int? get maxPhotoCount => _maxPhotoCount;

  void setFilm({
    Camera? camera,
    FilmStock? filmStock,
    int? maxPhotoCount,
  }) {
    _camera = camera;
    _filmStock = filmStock;
    _maxPhotoCount = maxPhotoCount;
  }
}
