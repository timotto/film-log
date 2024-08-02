import 'package:flutter/material.dart';

class EditTextDialog extends StatefulWidget {
  static Future<String?> show(
    BuildContext context, {
    required String label,
    required String value,
    required bool multiline,
  }) async {
    final result = await showDialog(
      context: context,
      builder: (context) => EditTextDialog(
        label: label,
        value: value,
        multiline: multiline,
      ),
    );
    return result;
  }

  const EditTextDialog({
    super.key,
    required this.label,
    required this.value,
    required this.multiline,
  });

  final String label;
  final String value;
  final bool multiline;

  @override
  State<StatefulWidget> createState() => _EditTextDialog();
}

class _EditTextDialog extends State<EditTextDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(
      text: widget.value,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onOk(BuildContext context) => Navigator.of(context).pop(
        _controller.value.text,
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
          keyboardType:
              widget.multiline ? TextInputType.multiline : TextInputType.text,
          maxLines: widget.multiline ? 5 : 1,
          textCapitalization: TextCapitalization.words,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => _onCancel(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _onOk(context),
            child: const Text('OK'),
          ),
        ],
      );
}
