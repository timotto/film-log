import 'package:film_log_wear/widgets/swipe_dismiss.dart';
import 'package:film_log_wear/widgets/wear_select_list_view.dart';
import 'package:film_log_wear_data/common/fmt/frame_number.dart';
import 'package:flutter/material.dart';

class EditFrameNumberPage extends StatelessWidget {
  const EditFrameNumberPage({
    super.key,
    required this.value,
    required this.values,
  });

  final int? value;
  final List<int> values;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SwipeDismiss(
      child: WearSelectListView(
        value: value,
        values: values,
        titleBuilder: formatFrameNumber,
      ),
    ),
  );
}
