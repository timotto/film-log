import 'package:film_log/model/film_stock.dart';

import '../model/camera.dart';
import '../model/filter.dart';
import '../model/lens.dart';

class LruService {
  LruService._();

  static final LruService sharedInstance = LruService._();

  factory LruService() => sharedInstance;

  Lens? _lens;
  double? _shutter;
  double? _aperture;
  List<Filter> _filters = [];

  Lens? get lens => _lens;

  double? get shutter => _shutter;

  double? get aperture => _aperture;

  List<Filter> get filters => [..._filters];

  void setPhoto({
    Lens? lens,
    double? shutter,
    double? aperture,
    List<Filter> filters = const [],
  }) {
    _lens = lens;
    _shutter = shutter;
    _aperture = aperture;
    _filters = filters;
  }

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
