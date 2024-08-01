String formatAperture(double value) {
  if (value.floorToDouble() == value) {
    return 'f${value.toStringAsFixed(0)}';
  }
  return 'f${value.toStringAsFixed(1)}';
}

String formatApertureRange(double min, double max) {
  if (min == max) {
    return formatAperture(min);
  }

  return '${formatAperture(min)} - ${formatAperture(max)}';
}
