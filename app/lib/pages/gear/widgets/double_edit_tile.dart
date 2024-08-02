import 'package:film_log/dialogs/edit_double_dialog/edit_double_dialog.dart';
import 'package:flutter/material.dart';

class DoubleEditTile extends StatelessWidget {
  const DoubleEditTile({
    super.key,
    required this.label,
    this.min,
    this.max,
    required this.value,
    required this.edit,
    required this.valueToString,
    required this.stringToValue,
    required this.onUpdate,
  });

  final String label;
  final double? min;
  final double? max;
  final double value;
  final bool edit;
  final String Function(double) valueToString;
  final double? Function(String) stringToValue;
  final void Function(double) onUpdate;

  Future<void> _onTap(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (context) => EditDoubleDialog(
        label: label,
        value: value,
        min: min,
        max: max,
        valueToString: valueToString,
        stringToValue: stringToValue,
      ),
    );

    if (result == null) return;
    onUpdate(result);
  }

  @override
  Widget build(BuildContext context) => ListTile(
        onTap: edit ? () => _onTap(context) : null,
        title: Text(valueToString(value)),
        subtitle: Text(label),
        trailing: edit ? const Icon(Icons.edit) : null,
      );
}
