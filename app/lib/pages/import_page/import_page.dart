import 'package:file_picker/file_picker.dart';
import 'package:film_log/service/import.dart';
import 'package:film_log/service/repos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ImportPage extends StatefulWidget {
  const ImportPage({super.key, required this.repos});

  final Repos repos;

  @override
  State<StatefulWidget> createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  late final ImportService _importService;

  ImportArchive? _archive;

  @override
  void initState() {
    _importService = ImportService(repos: widget.repos);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).pageTitleImport),
        ),
        body: ListView(
          children: [
            ListTile(
              title: Text(
                AppLocalizations.of(context).importPageTileWarning,
              ),
            ),
            ListTile(
              title: Text(
                AppLocalizations.of(context).importPageTileSelectArchive,
              ),
              subtitle: _archiveSubtitle(),
              trailing: const Icon(Icons.file_open),
              onTap: () => _selectFile(context),
            ),
            ElevatedButton(
              onPressed: _archive == null ? null : () => _import(context),
              child: Text(
                AppLocalizations.of(context).importPageButtonImportData,
              ),
            ),
            ..._content(context),
          ],
        ),
      );

  Widget? _archiveSubtitle() =>
      _archive == null ? null : Text(_archive!.basename);

  Future<void> _selectFile(BuildContext context) async {
    setState(() {
      _archive = null;
    });

    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: AppLocalizations.of(context).importPageFilePickerTitle,
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );
    if (result == null || result.xFiles.isEmpty) return;
    final file = result.xFiles.first;

    final archive = await _importService.loadArchive(file.path);
    if (archive == null) {
      if (!mounted || !context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context).importPageFileOpenError),
      ));
      return;
    }

    setState(() {
      _archive = archive;
    });
  }

  List<Widget> _content(BuildContext context) => _archive == null
      ? []
      : [
          ListTile(
              title: Text(AppLocalizations.of(context)
                  .countCameras(_archive!.cameras.length))),
          ListTile(
              title: Text(AppLocalizations.of(context)
                  .countLenses(_archive!.lenses.length))),
          ListTile(
              title: Text(AppLocalizations.of(context)
                  .countFilters(_archive!.filters.length))),
          ListTile(
              title: Text(AppLocalizations.of(context)
                  .countFilmStocks(_archive!.filmStock.length))),
          ListTile(
              title: Text(AppLocalizations.of(context)
                  .countFilmInstances(_archive!.films.length))),
          ListTile(
              title: Text(
                  AppLocalizations.of(context).countPhotos(_countPhotos()))),
        ];

  int _countPhotos() => _archive == null
      ? 0
      : _archive!.films
          .map((film) => film.photos.length)
          .reduce((a, b) => a + b);

  Future<void> _import(BuildContext context) async {
    _importService.importArchive(_archive!);
    Navigator.pop(context);
  }
}
