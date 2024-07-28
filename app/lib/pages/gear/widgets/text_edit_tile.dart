import 'package:film_log/dialogs/edit_text_dialog/edit_text_dialog.dart';
import 'package:flutter/material.dart';

class TextEditTile extends StatelessWidget {
  const TextEditTile({
    super.key,
    required this.label,
    required this.value,
    required this.edit,
    this.multiline = false,
    required this.onUpdate,
  });

  final String label;
  final String value;
  final bool edit;
  final bool multiline;
  final void Function(String) onUpdate;

  Future<void> _onTap(BuildContext context) async {
    final result = await EditTextDialog.show(
      context,
      label: label,
      value: value,
      multiline: multiline,
    );
    if (result == null) return;
    onUpdate(result);
  }

  @override
  Widget build(BuildContext context) => ListTile(
        onTap: edit ? () => _onTap(context) : null,
        title: _title(),
        subtitle: _subtitle(),
        trailing: edit ? const Icon(Icons.edit) : null,
      );

  Widget _title() => multiline ? Text(label) : Text(value);

  Widget _subtitle() => multiline ? Text(value) : Text(label);
}
