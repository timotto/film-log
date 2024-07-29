import 'package:film_log/dialogs/edit_thumbnail_dialog/edit_thumbnail_dialog.dart';
import 'package:film_log/model/thumbnail.dart';
import 'package:flutter/material.dart';

import '../service/thumbnail_repo.dart';

class ThumbnailListTile extends StatelessWidget {
  const ThumbnailListTile({
    super.key,
    required this.label,
    required this.value,
    required this.repo,
    required this.edit,
    required this.onUpdate,
  });

  final String label;
  final Thumbnail? value;
  final ThumbnailRepo repo;
  final bool edit;
  final void Function(Thumbnail?) onUpdate;

  Future<void> _edit(BuildContext context) async {
    final EditThumbnailResult? result = await showDialog(
      context: context,
      builder: (_) => EditThumbnailDialog(
        label: label,
        value: value,
        repo: repo,
      ),
    );
    if (result == null || !context.mounted) return;
    onUpdate(result.value);
  }

  void Function()? _onTap(BuildContext context) =>
      edit ? () => _edit(context) : null;

  @override
  Widget build(BuildContext context) => ListTile(
        title: _title(context),
        subtitle: _subtitle(context),
        trailing: _trailing(context),
        onTap: _onTap(context),
      );

  Widget? _title(BuildContext context) => Text(label);

  Widget? _subtitle(BuildContext context) => value != null
      ? Image(
          image: ResizeImage(
            FileImage(repo.file(value!)),
            height: 300,
          ),
        )
      : null;

  Widget? _trailing(BuildContext context) =>
      edit ? const Icon(Icons.edit) : null;
}
