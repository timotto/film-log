import 'package:film_log/dialogs/edit_value_dialog/edit_value_dialog.dart';
import 'package:flutter/material.dart';

typedef ValueToStringFn<T> = String Function(T);
typedef StringToValueFn<T> = T? Function(String);

class GearValueEditTile<T> extends StatelessWidget {
  const GearValueEditTile({
    super.key,
    required this.label,
    required this.value,
    required this.edit,
    required this.valueToString,
    required this.stringToValueFn,
    required this.onUpdate,
  });

  final String label;
  final T value;
  final bool edit;
  final ValueToStringFn<T> valueToString;
  final StringToValueFn<T> stringToValueFn;
  final void Function(T) onUpdate;

  Future<void> _onTap(BuildContext context) async {
    final result = await EditValueDialog.show<T>(
      context,
      label: label,
      value: value,
      valueToStringFn: valueToString,
      stringToValueFn: stringToValueFn,
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
