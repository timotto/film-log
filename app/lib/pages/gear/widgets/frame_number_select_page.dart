import 'package:film_log/widgets/frame_number_list_widget.dart';
import 'package:flutter/material.dart';

class FrameNumberSelectPage extends StatelessWidget {
  const FrameNumberSelectPage({
    super.key,
    required this.label,
    required this.value,
    required this.items,
  });

  final String label;
  final List<int> items;
  final int? value;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(label)),
    body: FrameNumberListWidget(
      items: items,
      value: value,
      onTap: (value) => Navigator.of(context).pop(value),
    ),
  );
}
