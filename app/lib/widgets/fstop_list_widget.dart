import 'package:film_log/fmt/aperture.dart';
import 'package:film_log/model/fstop.dart';
import 'package:film_log/widgets/select_list_widget.dart';
import 'package:flutter/material.dart';

class FStopListWidget extends StatelessWidget {
  const FStopListWidget({
    super.key,
    required this.increments,
    this.min,
    this.max,
    this.value,
    required this.onTap,
  });

  final FStopIncrements increments;
  final double? min, max;
  final double? value;
  final void Function(double) onTap;

  @override
  Widget build(BuildContext context) => SelectListWidget(
        items: _items(),
        value: value,
        onTap: onTap,
      );

  List<MapEntry<double, String>> _items() => fStopScale(increments)
      .where(_inRange)
      .map((value) => MapEntry(value, formatAperture(value)))
      .toList(growable: false);

  bool _inRange(double value) {
    if (min != null && value < min!) return false;
    if (max != null && value > max!) return false;
    return true;
  }
}
