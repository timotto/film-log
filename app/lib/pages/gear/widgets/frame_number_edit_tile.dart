import 'package:film_log_wear_data/common/fmt/frame_number.dart';
import 'package:flutter/material.dart';

import 'frame_number_select_page.dart';

class FrameNumberEditTile extends StatelessWidget {
  const FrameNumberEditTile({
    super.key,
    required this.label,
    required this.edit,
    required this.value,
    required this.items,
    required this.onUpdate,
  });

  final String label;
  final bool edit;
  final int? value;
  final List<int> items;
  final void Function(int) onUpdate;

  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(value != null ? formatFrameNumber(value!) : '-'),
    subtitle: Text(label),
    trailing: edit ? const Icon(Icons.edit) : null,
    onTap: edit ? () => _onTap(context) : null,
  );

  Future<void> _onTap(BuildContext context) async {
    final result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => FrameNumberSelectPage(
        label: label,
        value: value,
        items: items,
      ),
    ));

    if (result != null) {
      onUpdate(result);
    }
  }
}
