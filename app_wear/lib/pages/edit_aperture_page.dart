import 'package:film_log_wear/widgets/swipe_dismiss.dart';
import 'package:film_log_wear/widgets/wear_select_list_view.dart';
import 'package:flutter/material.dart';

import '../fmt/aperture.dart';

class EditAperturePage extends StatelessWidget {
  const EditAperturePage({
    super.key,
    required this.value,
    required this.values,
  });

  final double? value;
  final List<double> values;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SwipeDismiss(
          child: WearSelectListView(
            value: value,
            values: values,
            titleBuilder: formatAperture,
          ),
        ),
      );
}
