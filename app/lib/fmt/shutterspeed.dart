String formatShutterSpeed(double value) {
  if (value >= 1) {
    return value.toStringAsFixed(1);
  }

  final inv = 1 / value;
  return '1/${inv.toStringAsFixed(0)}';
}