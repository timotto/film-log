import 'package:film_log/fmt/shutterspeed.dart';
import 'package:film_log/model/shutter_speed.dart';
import 'package:film_log/widgets/select_list_widget.dart';
import 'package:flutter/material.dart';

class ShutterSpeedListWidget extends StatelessWidget {
  const ShutterSpeedListWidget({
    super.key,
    this.min,
    this.max,
    this.value,
    required this.onTap,
  });

  final double? min, max;
  final double? value;
  final void Function(double) onTap;

  @override
  Widget build(BuildContext context) => SelectListWidget(
        items: _items(),
        value: value,
        onTap: onTap,
      );

  List<MapEntry<double, String>> _items() => shutterSpeeds()
      .where(_inRange)
      .map((value) => MapEntry(value, formatShutterSpeed(value)))
      .toList(growable: false);

  bool _inRange(double value) {
    if (min != null && value < min!) return false;
    if (max != null && value > max!) return false;
    return true;
  }
}
