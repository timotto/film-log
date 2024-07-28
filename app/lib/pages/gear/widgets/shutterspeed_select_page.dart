import 'package:film_log/widgets/shutter_list_widget.dart';
import 'package:flutter/material.dart';

class ShutterSpeedSelectPage extends StatelessWidget {
  const ShutterSpeedSelectPage({
    super.key,
    required this.label,
    required this.value,
    this.min,
    this.max,
  });

  final String label;
  final double? min, max;
  final double? value;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(label)),
    body: ShutterSpeedListWidget(
      min: min,
      max: max,
      value: value,
      onTap: (value) => Navigator.of(context).pop(value),
    ),
  );
}
