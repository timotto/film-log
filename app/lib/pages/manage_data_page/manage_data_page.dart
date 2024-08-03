import 'package:film_log/pages/import_page/import_page.dart';
import 'package:film_log/service/export.dart';
import 'package:film_log/service/repos.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ManageDataPage extends StatelessWidget {
  const ManageDataPage({super.key, required this.repos});

  final Repos repos;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Manage data'),
        ),
        body: ListView(
          children: [
            ListTile(
              title: const Text('Export data'),
              subtitle: const Text(
                  'Store all data contained in the app in a ZIP archive.'),
              leading: const Icon(Icons.send),
              onTap: () => _export(context),
            ),
            ListTile(
              title: const Text('Import data'),
              subtitle: const Text('Restore app data from a ZIP archive.'),
              leading: const Icon(Icons.file_open),
              onTap: () => _import(context),
            ),
            ListTile(
              title: const Text('Delete everything'),
              leading: const Icon(Icons.delete_forever),
              onTap: () => _delete(context),
            ),
          ],
        ),
      );

  Future<void> _export(BuildContext context) async {
    await ExportService(repos: repos).exportAll((filename) async {
      await Share.shareXFiles(
        [XFile(filename)],
        text: 'Film Log full export',
      );
    });
  }

  Future<void> _import(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ImportPage(repos: repos),
      ),
    );
  }

  Future<void> _delete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete all data'),
        content: const Text('Are you sure you want to delete all data?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    if (!(result ?? false) || !context.mounted) return;

    await _deleteConfirmed();

    if (!context.mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _deleteConfirmed() async {
    await repos.thumbnailRepo.deleteAll();
    await repos.cameraRepo.replaceItems([]);
    await repos.lensRepo.replaceItems([]);
    await repos.filterRepo.replaceItems([]);
    await repos.filmstockRepo.replaceItems([]);
    await repos.filmRepo.replaceItems([]);
  }
}
