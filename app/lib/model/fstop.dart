enum FStopIncrements {
  full,
  half,
  third;

  dynamic toJson() => name;

  factory FStopIncrements.fromJson(dynamic json) =>
      FStopIncrements.values.where((v) => v.name == json).first;
}

List<double> fStopScale(FStopIncrements increments) {
  switch (increments) {
    case FStopIncrements.full:
      return fStopsWhole();
    case FStopIncrements.half:
      return fStopsHalf();
    case FStopIncrements.third:
      return fStopsThird();
  }
}

List<double> fStopsWhole() => [
      0.5,
      0.7,
      1.0,
      1.4,
      2,
      2.8,
      4,
      5.6,
      8,
      11,
      16,
      22,
      32,
      45,
      64,
      90,
      128,
    ];

List<double> fStopsHalf() => [
      0.7,
      0.8,
      1.0,
      1.2,
      1.4,
      1.7,
      2,
      2.4,
      2.8,
      3.3,
      4,
      4.8,
      5.6,
      6.7,
      8,
      9.5,
      11,
      13,
      16,
      19,
      22,
      27,
      32,
      38,
      45,
      54,
      64,
      76,
      90,
      107,
      128,
    ];

List<double> fStopsThird() => [
      0.7,
      0.8,
      0.9,
      1.0,
      1.1,
      1.2,
      1.4,
      1.6,
      1.8,
      2,
      2.2,
      2.5,
      2.8,
      3.2,
      3.5,
      4,
      4.5,
      5.0,
      5.6,
      6.3,
      7.1,
      8,
      9,
      10,
      11,
      13,
      14,
      16,
      18,
      20,
      22,
      25,
      29,
      32,
      36,
      40,
      45,
      51,
      57,
      64,
      72,
      80,
      90,
      101,
      114,
      128,
    ];
