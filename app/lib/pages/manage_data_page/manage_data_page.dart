import 'package:film_log/pages/import_page/import_page.dart';
import 'package:film_log/service/export.dart';
import 'package:film_log/service/repos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

class ManageDataPage extends StatelessWidget {
  const ManageDataPage({super.key, required this.repos});

  final Repos repos;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).pageTitleManageData),
        ),
        body: ListView(
          children: [
            ListTile(
              title: Text(
                AppLocalizations.of(context).manageDataTileExportDataTitle,
              ),
              subtitle: Text(
                AppLocalizations.of(context).manageDataTileExportDataSubtitle,
              ),
              leading: const Icon(Icons.send),
              onTap: () => _export(context),
            ),
            ListTile(
              title: Text(
                AppLocalizations.of(context).manageDataTileImportDataTitle,
              ),
              subtitle: Text(
                AppLocalizations.of(context).manageDataTileImportDataSubtitle,
              ),
              leading: const Icon(Icons.file_open),
              onTap: () => _import(context),
            ),
            ListTile(
              title: Text(
                AppLocalizations.of(context).manageDataTileDeleteTitle,
              ),
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
        text: AppLocalizations.of(context).manageDataExportPickerTitle,
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
        title: Text(AppLocalizations.of(context).dialogDeleteAllDataTitle),
        content: Text(AppLocalizations.of(context).dialogDeleteAllDataContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context).buttonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              AppLocalizations.of(context).buttonDelete,
              style: const TextStyle(color: Colors.red),
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
