import 'package:film_log/fmt/aperture.dart';
import 'package:film_log/model/fstop.dart';
import 'package:flutter/material.dart';

import 'aperture_select_page.dart';

class ApertureEditTile extends StatelessWidget {
  const ApertureEditTile({
    super.key,
    required this.label,
    required this.edit,
    required this.value,
    this.min,
    this.max,
    required this.increments,
    required this.onUpdate,
  });

  final String label;
  final bool edit;
  final double? value;
  final double? min, max;
  final FStopIncrements increments;
  final void Function(double) onUpdate;

  @override
  Widget build(BuildContext context) => ListTile(
        subtitle: Text(label),
        title: Text(value != null ? formatAperture(value!) : ''),
        trailing: edit ? const Icon(Icons.edit) : null,
        onTap: edit ? () => _onTap(context) : null,
      );

  Future<void> _onTap(BuildContext context) async {
    final result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ApertureSelectPage(
        label: label,
        increments: increments,
        value: value,
        min: min,
        max: max,
      ),
    ));
    if (result != null) {
      onUpdate(result);
    }
  }
}
