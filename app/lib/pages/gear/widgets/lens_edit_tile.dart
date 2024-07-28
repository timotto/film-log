import 'package:film_log/model/camera.dart';
import 'package:film_log/model/lens.dart';
import 'package:film_log/service/lens_repo.dart';
import 'package:flutter/material.dart';

import 'gear_select_page.dart';

class LensEditTile extends StatelessWidget {
  const LensEditTile({
    super.key,
    required this.label,
    this.value,
    required this.repo,
    this.camera,
    required this.edit,
    required this.onUpdate,
  });

  final String label;
  final Lens? value;
  final LensRepo repo;
  final Camera? camera;
  final bool edit;
  final void Function(Lens) onUpdate;

  Future<void> _onTap(BuildContext context) async {
    final result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) =>
          GearSelectPage<Lens>(
            label: label,
            value: value,
            repo: repo,
            filter: _filter(),
          ),
    ));
    if (result != null) {
      onUpdate(result);
    }
  }

  bool Function(Lens)? _filter() =>
      camera == null ? null : (item) =>
      item.cameras
          .where((item) => item.id == camera?.id)
          .isNotEmpty;

  @override
  Widget build(BuildContext context) =>
      ListTile(
        title: Text(value?.listItemTitle() ?? ''),
        subtitle: Text(label),
        trailing: edit ? const Icon(Icons.edit) : null,
        onTap: edit ? () => _onTap(context) : null,
      );
}
