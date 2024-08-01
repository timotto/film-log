import 'package:film_log_wear/widgets/wear_select_list_view.dart';
import 'package:flutter/material.dart';

import '../fmt/shutter_speed.dart';

class EditShutterSpeedPage extends StatelessWidget {
  const EditShutterSpeedPage({
    super.key,
    required this.value,
    required this.values,
  });

  final double? value;
  final List<double> values;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: WearSelectListView(
          value: value,
          values: values,
          titleBuilder: formatShutterSpeed,
        ),
      );
}
