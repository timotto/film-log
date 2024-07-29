import 'package:film_log/model/location.dart';
import 'package:film_log/service/location.dart';
import 'package:flutter/material.dart';

class EditLocationDialog extends StatefulWidget {
  const EditLocationDialog({super.key, required this.label, this.value});

  final String label;
  final Location? value;

  @override
  State<StatefulWidget> createState() => _EditLocationDialogState();
}

class _EditLocationDialogState extends State<EditLocationDialog> {
  late TextEditingController _controller;
  late Location? value;
  bool _loadingLocation = false;

  @override
  void initState() {
    value = widget.value;
    _controller = TextEditingController(
      text: value?.toString(),
    );
    _controller.addListener(_onTextInput);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTextInput() {
    setState(() {
      value = Location.tryParse(_controller.value.text);
    });
  }

  void _onOk(BuildContext context) {
    Navigator.of(context).pop(EditLocationResult.value(value));
  }

  void _onCancel(BuildContext context) => Navigator.of(context).pop();

  void _onClear(BuildContext context) =>
      Navigator.of(context).pop(EditLocationResult.delete());

  Future<void> _currentLocation(BuildContext context) async {
    try {
      setState(() {
        _loadingLocation = true;
      });
      final result = await getLocation();
      if (result != null) {
        value = result;
        _controller.text = result.toString();
      }
    } finally {
      if (mounted && context.mounted) {
        setState(() {
          _loadingLocation = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.label),
        actions: [
          TextButton(
            onPressed: () => _onClear(context),
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: () => _onCancel(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: value != null ? () => _onOk(context) : null,
            child: const Text('OK'),
          ),
        ],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: widget.label,
                suffixIcon: IconButton(
                  onPressed:
                      _loadingLocation ? null : () => _currentLocation(context),
                  icon: const Icon(Icons.gps_fixed),
                ),
              ),
            ),
          ],
        ),
      );
}

class EditLocationResult {
  final Location? value;
  final bool delete;

  EditLocationResult._({this.value, this.delete = false});

  factory EditLocationResult.value(Location? value) =>
      EditLocationResult._(value: value);

  factory EditLocationResult.delete() => EditLocationResult._(delete: true);
}
