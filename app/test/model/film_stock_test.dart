import 'dart:convert';

import 'package:film_log/model/film_stock.dart';
import 'package:film_log/model/filmstock_format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FilmStock', () {
    group('json', () {
      test('marshal/unmarshal', () {
        final uut = FilmStock(
          id: '1',
          manufacturer: 'Kodak',
          product: 'Kodak Gold',
          iso: 200,
          format: FilmStockFormat.type120,
          type: FilmStockType.color,
        );

        final json = jsonEncode(uut.toJson());

        final result = FilmStock.fromJson(jsonDecode(json));

        expect(result, equals(uut));
      });
    });
  });
}
