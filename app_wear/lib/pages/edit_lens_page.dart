import 'package:film_log_wear/model/lens.dart';
import 'package:film_log_wear/widgets/swipe_dismiss.dart';
import 'package:film_log_wear/widgets/wear_select_list_view.dart';
import 'package:flutter/material.dart';

class EditLensPage extends StatelessWidget {
  const EditLensPage({
    super.key,
    this.value,
    required this.values,
  });

  final Lens? value;
  final List<Lens> values;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SwipeDismiss(
          child: WearSelectListView(
            value: value,
            values: values,
            titleBuilder: (lens) => lens.label,
          ),
        ),
      );
}
