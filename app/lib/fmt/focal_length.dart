String formatFocalLength(double value) {
  final digits = value.floorToDouble() == value ? 0 : 1;

  return '${value.toStringAsFixed(digits)}mm';
}

String formatFocalLengthRange(double min, double max) {
  if (min == max) {
    return formatFocalLength(min);
  }

  return '${formatFocalLength(min)} - ${formatFocalLength(max)}';
}
