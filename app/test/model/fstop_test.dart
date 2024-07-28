import 'dart:math';

void main() {
  // 1 1.4 2 2.8 4 5.6 8 11 16 22 32 45 64

  // List<double> fStops = [
  //   1,
  //   1.4,
  //   2,
  //   2.8,
  //   4,
  //   5.6,
  //   8,
  //   11,
  //   16,
  //   22,
  //   32,
  //   45,
  //   64,
  // ];

  // fStops.forEach((value) => print(1/value));
  // for(var i = 0; i < 15; i ++) {
  //   final f = pow(sqrt(2), i);
  //   final digits = f < 10 ? 1 : 0;
  //   print(f.toStringAsFixed(digits));
  // }

  final result = fStops(stepDivider: 3, max: 128);
  print(result.map((v) => v < 10 ? v.toStringAsFixed(2) : v.toStringAsFixed(1)).join(','));
}

List<double> fStops({required double stepDivider, required double max}) {
  final List<double> result = [];

  double pwr = 0;
  final increment = 1 /stepDivider;

  while (true) {
    final value = pow(sqrt2, pwr).toDouble();
    if (value > max) break;

    // result.add(value >= 10 ? value.floorToDouble() : value);
    result.add(value);
    pwr += increment;
  }

  return result;
}