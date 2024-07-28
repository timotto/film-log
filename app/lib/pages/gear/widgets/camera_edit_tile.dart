import 'package:film_log/model/camera.dart';
import 'package:film_log/pages/gear/widgets/gear_select_page.dart';
import 'package:film_log/service/camera_repo.dart';
import 'package:flutter/material.dart';

class CameraEditTile extends StatelessWidget {
  const CameraEditTile({
    super.key,
    required this.label,
    required this.value,
    required this.repo,
    required this.edit,
    required this.onUpdate,
  });

  final String label;
  final Camera? value;
  final CameraRepo repo;
  final bool edit;
  final void Function(Camera?) onUpdate;

  Future<void> _onTap(BuildContext context) async {
    final result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => GearSelectPage<Camera>(
        label: label,
        value: value,
        repo: repo,
      ),
    ));
    if (result != null) {
      onUpdate(result);
    }
  }

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(value?.listItemTitle() ?? ''),
        subtitle: Text(label),
        trailing: edit ? const Icon(Icons.edit) : null,
        onTap: edit ? () => _onTap(context) : null,
      );
}
