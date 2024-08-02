import 'package:flutter/material.dart';

class EditDoubleDialog extends StatefulWidget {
  const EditDoubleDialog({
    super.key,
    required this.label,
    this.min,
    this.max,
    required this.value,
    required this.valueToString,
    required this.stringToValue,
  });

  final String label;
  final double? min, max;
  final double value;
  final String Function(double) valueToString;
  final double? Function(String) stringToValue;

  @override
  State<StatefulWidget> createState() => _EditDoubleDialogState();
}

class _EditDoubleDialogState extends State<EditDoubleDialog> {
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
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _onOk(context),
            child: const Text('OK'),
          ),
        ],
      );
}
