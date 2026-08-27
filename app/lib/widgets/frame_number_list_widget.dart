import 'package:film_log_wear_data/common/fmt/frame_number.dart';
import 'package:film_log/widgets/select_list_widget.dart';
import 'package:flutter/material.dart';

class FrameNumberListWidget extends StatelessWidget {
  const FrameNumberListWidget({
    super.key,
    this.value,
    required this.items,
    required this.onTap,
  });

  final int? value;
  final List<int> items;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) => SelectListWidget(
        items: items.map((value) => MapEntry(value, formatFrameNumber(value)))
            .toList(growable: false),
        value: value,
        onTap: onTap,
      );
}
