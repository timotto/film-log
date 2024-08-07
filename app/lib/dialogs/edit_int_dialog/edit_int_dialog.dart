import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditIntDialog extends StatefulWidget {
  const EditIntDialog({
    super.key,
    required this.label,
    this.min,
    this.max,
    required this.value,
    required this.valueToString,
    required this.stringToValue,
  });

  final String label;
  final int? min, max;
  final int? value;
  final String Function(int?) valueToString;
  final int? Function(String) stringToValue;

  @override
  State<StatefulWidget> createState() => _EditIntDialogState();
}

class _EditIntDialogState extends State<EditIntDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(
      text: widget.valueToString(widget.value),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onOk(BuildContext context) => Navigator.of(context).pop(
        widget.stringToValue(_controller.value.text),
      );

  void _onCancel(BuildContext context) => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.label),
        content: TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: widget.label,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => _onCancel(context),
            child: Text(AppLocalizations.of(context).buttonCancel),
          ),
          TextButton(
            onPressed: () => _onOk(context),
            child: Text(AppLocalizations.of(context).buttonOK),
          ),
        ],
      );
}
