import 'package:film_log/fmt/timestamp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditTimestampDialog extends StatefulWidget {
  const EditTimestampDialog({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final DateTime value;

  @override
  State<StatefulWidget> createState() => _EditTimestampDialogState();
}

class _EditTimestampDialogState extends State<EditTimestampDialog> {
  late DateTime value;

  @override
  void initState() {
    value = widget.value;
    super.initState();
  }

  Future<void> _ok(BuildContext context) async =>
      Navigator.of(context).pop(value);

  Future<void> _cancel(BuildContext context) async =>
      Navigator.of(context).pop();

  Future<void> _editTime(BuildContext context) async {
    final TimeOfDay? result = await showDialog(
        context: context,
        builder: (context) => TimePickerDialog(
              initialTime: TimeOfDay.fromDateTime(value),
            ));
    if (result == null || !mounted || !context.mounted) return;
    setState(() {
      value = DateTime(
        value.year,
        value.month,
        value.day,
        result.hour,
        result.minute,
      );
    });
  }

  Future<void> _editDate(BuildContext context) async {
    final tod = TimeOfDay.fromDateTime(value);
    final DateTime? result = await showDialog(
        context: context,
        builder: (context) => DatePickerDialog(
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
              initialDate: value,
            ));
    if (result == null || !mounted || !context.mounted) return;
    setState(() {
      value = DateTime(
        result.year,
        result.month,
        result.day,
        tod.hour,
        tod.minute,
      );
    });
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.label),
        actions: [
          TextButton(
            onPressed: () => _cancel(context),
            child: Text(AppLocalizations.of(context).buttonCancel),
          ),
          TextButton(
            onPressed: () => _ok(context),
            child: Text(AppLocalizations.of(context).buttonOK),
          ),
        ],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              subtitle: Text(formatTime(context, value)),
              title: Text(AppLocalizations.of(context).buttonChangeTime),
              onTap: () => _editTime(context),
            ),
            ListTile(
              subtitle: Text(formateDate(context, value)),
              title: Text(AppLocalizations.of(context).buttonChangeDate),
              onTap: () => _editDate(context),
            ),
          ],
        ),
      );
}
