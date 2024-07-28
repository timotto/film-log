import 'package:flutter/material.dart';

class RangeEditDialog extends StatefulWidget {
  static Future<RangeValues?> show(
    BuildContext context, {
    required String label,
    required RangeValues limits,
    required RangeValues values,
    required String Function(RangeValues) valuesToString,
  }) async {
    return await showDialog(
      context: context,
      builder: (context) => RangeEditDialog(
        label: label,
        limits: limits,
        values: values,
        valuesToString: valuesToString,
      ),
    );
  }

  const RangeEditDialog({
    super.key,
    required this.label,
    required this.limits,
    required this.values,
    required this.valuesToString,
  });

  final String label;
  final RangeValues limits;
  final RangeValues values;
  final String Function(RangeValues) valuesToString;

  @override
  State<StatefulWidget> createState() => _RangeEditDialogState();
}

class _RangeEditDialogState extends State<RangeEditDialog> {
  late RangeValues values;

  @override
  void initState() {
    values = widget.values;
    super.initState();
  }

  void _onChanged(RangeValues? value) {
    if (value == null) return;
    setState(() {
      values = value;
    });
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.label),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RangeSlider(
              min: widget.limits.start,
              max: widget.limits.end,
              values: values,
              onChanged: _onChanged,
            ),
            Center(
              child: Text(widget.valuesToString(values)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(values),
            child: const Text('OK'),
          ),
        ],
      );
}

class RangeEditResult {
  final double lowValue;
  final double highValue;

  RangeEditResult({required this.lowValue, required this.highValue});
}
