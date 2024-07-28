enum FilmStockFormat {
  type120,
  type127,
  type135,
  typeOther;

  dynamic toJson() => name;

  factory FilmStockFormat.fromJson(dynamic json) =>
      FilmStockFormat.values.where((v) => v.name == json).first;
}
