import 'package:film_log/dialogs/edit_timestamp_dialog/edit_timestamp_dialog.dart';
import 'package:film_log/fmt/timestamp.dart';
import 'package:flutter/material.dart';

class TimestampListTile extends StatelessWidget {
  const TimestampListTile({
    super.key,
    required this.label,
    required this.value,
    this.otherValues = const [],
    required this.edit,
    required this.onUpdate,
  });

  final String label;
  final DateTime value;
  final List<DateTime> otherValues;
  final bool edit;
  final void Function(DateTime) onUpdate;

  void Function()? _onTap(BuildContext context) => edit
      ? () async {
          final DateTime? result = await showDialog(
              context: context,
              builder: (context) => EditTimestampDialog(
                    label: label,
                    value: value,
                  ));
          if (result == null || !context.mounted) return;
          onUpdate(result);
        }
      : null;

  @override
  Widget build(BuildContext context) => ListTile(
        title: _title(context),
        subtitle: _subtitle(context),
        trailing: _trailing(context),
        onTap: _onTap(context),
      );

  Widget _title(BuildContext context) => Text(formatTimestamp(
        context,
        value,
        values: otherValues,
      ));

  Widget _subtitle(BuildContext context) => Text(label);

  Widget? _trailing(BuildContext context) =>
      edit ? const Icon(Icons.edit) : null;
}
