import 'package:film_log_wear_data/model/film_stock.dart';

import 'camera.dart';
import 'film.dart';
import 'filter.dart';
import 'lens.dart';

/// The [State] object is synchronized by the phone app and listened to by
/// the Wear OS app. It contains the known state of the phone app.
class State {
  const State({
    required this.films,
    required this.filters,
    required this.lenses,
    required this.cameras,
    required this.filmStocks,
  });

  final List<Film> films;
  final List<Filter> filters;
  final List<Lens> lenses;
  final List<Camera> cameras;
  final List<FilmStock> filmStocks;

  factory State.fromJson(Map<String, dynamic> json) => State(
        films: (json['films'] as List<dynamic>)
            .map((item) => Film.fromJson(item))
            .toList(growable: false),
        filters: (json['filters'] as List<dynamic>)
            .map((item) => Filter.fromJson(item))
            .toList(growable: false),
        lenses: (json['lenses'] as List<dynamic>)
            .map((item) => Lens.fromJson(item))
            .toList(growable: false),
        cameras: (json['cameras'] as List<dynamic>)
            .map((item) => Camera.fromJson(item))
            .toList(growable: false),
        filmStocks: json['filmStocks'] == null
            ? []
            : (json['filmStocks'] as List<dynamic>)
                .map((item) => FilmStock.fromJson(item))
                .toList(growable: false),
      );

  Map<String, dynamic> toJson() => {
        'films': films.map((item) => item.toJson()).toList(growable: false),
        'filters': filters.map((item) => item.toJson()).toList(growable: false),
        'lenses': lenses.map((item) => item.toJson()).toList(growable: false),
        'cameras': cameras.map((item) => item.toJson()).toList(growable: false),
        'filmStocks': filmStocks.map((item) => item.toJson()).toList(
              growable: false,
            ),
      };
}
