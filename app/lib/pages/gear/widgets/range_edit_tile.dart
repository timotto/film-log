import 'package:film_log/dialogs/range_edit_dialog/range_edit_dialog.dart';
import 'package:flutter/material.dart';

typedef ValuesToStringFn = String Function(RangeValues);

class RangeEditTile extends StatelessWidget {
  const RangeEditTile({
    super.key,
    required this.label,
    required this.edit,
    required this.limits,
    required this.values,
    required this.valuesToStringFn,
    required this.onUpdate,
  });

  final String label;
  final bool edit;
  final RangeValues limits;
  final RangeValues values;
  final ValuesToStringFn valuesToStringFn;
  final void Function(RangeValues) onUpdate;

  Future<void> _onTap(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (context) => RangeEditDialog(
        label: label,
        limits: limits,
        values: values,
        valuesToString: valuesToStringFn,
      ),
    );

    if (result != null) onUpdate(result);
  }

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(valuesToStringFn(values)),
        subtitle: Text(label),
        trailing: edit ? const Icon(Icons.edit) : null,
        onTap: edit ? () => _onTap(context) : null,
      );
}
