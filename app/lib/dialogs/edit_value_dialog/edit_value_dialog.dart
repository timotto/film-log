import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef ValueToStringFn<T> = String Function(T);
typedef StringToValueFn<T> = T? Function(String);

class EditValueDialog<T> extends StatefulWidget {
  static Future<T?> show<T>(
    BuildContext context, {
    required String label,
    required T value,
    required ValueToStringFn<T> valueToStringFn,
    required StringToValueFn<T> stringToValueFn,
  }) async {
    final result = await showDialog(
      context: context,
      builder: (context) => EditValueDialog<T>(
        label: label,
        value: value,
        valueToStringFn: valueToStringFn,
        stringToValueFn: stringToValueFn,
      ),
    );
    return result;
  }

  const EditValueDialog({
    super.key,
    required this.label,
    required this.value,
    required this.valueToStringFn,
    required this.stringToValueFn,
  });

  final String label;
  final T value;
  final ValueToStringFn<T> valueToStringFn;
  final StringToValueFn<T> stringToValueFn;

  @override
  State<StatefulWidget> createState() => _EditValueDialog();
}

class _EditValueDialog<T> extends State<EditValueDialog<T>> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(
      text: widget.valueToStringFn(widget.value),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onOk(BuildContext context) => Navigator.of(context).pop(
        widget.stringToValueFn(_controller.value.text),
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
