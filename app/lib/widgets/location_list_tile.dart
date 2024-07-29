import 'package:film_log/dialogs/edit_location_dialog/edit_location_dialog.dart';
import 'package:film_log/model/location.dart';
import 'package:flutter/material.dart';

class LocationListTile extends StatelessWidget {
  const LocationListTile({
    super.key,
    required this.label,
    required this.value,
    required this.edit,
    required this.onUpdate,
  });

  final String label;
  final Location? value;
  final bool edit;
  final void Function(Location?) onUpdate;

  void Function()? _onTap(BuildContext context) =>
      edit ? () => _edit(context) : null;

  Future<void> _edit(BuildContext context) async {
    final EditLocationResult? result = await showDialog(
        context: context,
        builder: (_) => EditLocationDialog(
              label: label,
              value: value,
            ));
    if (result == null || !context.mounted) return;
    onUpdate(result.value);
  }

  @override
  Widget build(BuildContext context) => ListTile(
        title: _title(),
        subtitle: _subtitle(),
        trailing: _trailing(),
        onTap: _onTap(context),
      );

  Widget? _title() =>
      value != null ? Text(value?.toString() ?? '') : Text(label);

  Widget? _subtitle() => value != null ? Text(label) : null;

  Widget? _trailing() => edit ? const Icon(Icons.edit) : null;
}
