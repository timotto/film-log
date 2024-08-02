import 'package:film_log/model/fstop.dart';
import 'package:film_log/widgets/fstop_list_widget.dart';
import 'package:flutter/material.dart';

class ApertureSelectPage extends StatelessWidget {
  const ApertureSelectPage({
    super.key,
    required this.label,
    required this.increments,
    this.min,
    this.max,
    required this.value,
  });

  final String label;
  final FStopIncrements increments;
  final double? min, max;
  final double? value;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(label)),
        body: FStopListWidget(
          increments: increments,
          value: value,
          min: min,
          max: max,
          onTap: (value) => Navigator.of(context).pop(value),
        ),
      );
}
