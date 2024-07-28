import 'package:film_log/fmt/shutterspeed.dart';
import 'package:flutter/material.dart';

import 'shutterspeed_select_page.dart';

class ShutterSpeedEditTile extends StatelessWidget {
  const ShutterSpeedEditTile({
    super.key,
    required this.label,
    required this.edit,
    required this.value,
    this.min,
    this.max,
    required this.onUpdate,
  });

  final String label;
  final bool edit;
  final double? value;
  final double? min, max;
  final void Function(double) onUpdate;

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(value != null ? formatShutterSpeed(value!) : '-'),
        subtitle: Text(label),
        trailing: edit ? const Icon(Icons.edit) : null,
        onTap: edit ? () => _onTap(context) : null,
      );

  Future<void> _onTap(BuildContext context) async {
    final result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ShutterSpeedSelectPage(
        label: label,
        value: value,
        min: min,
        max: max,
      ),
    ));

    if (result != null) {
      onUpdate(result);
    }
  }
}
