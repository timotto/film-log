import 'package:film_log/dialogs/edit_int_dialog/edit_int_dialog.dart';
import 'package:flutter/material.dart';

class IntEditTile extends StatelessWidget {
  const IntEditTile({
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
  final int? min;
  final int? max;
  final int? value;
  final bool edit;
  final String Function(int?) valueToString;
  final int? Function(String) stringToValue;
  final void Function(int) onUpdate;

  Future<void> _onTap(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (context) => EditIntDialog(
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
