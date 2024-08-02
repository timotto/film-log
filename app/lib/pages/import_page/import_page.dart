import 'package:file_picker/file_picker.dart';
import 'package:film_log/service/import.dart';
import 'package:film_log/service/repos.dart';
import 'package:flutter/material.dart';

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
          title: const Text('Import'),
        ),
        body: ListView(
          children: [
            const ListTile(
              title: Text(
                'Importing an archive will replace all your current data, gear and films.',
              ),
            ),
            ListTile(
              title: const Text('Select archive to import'),
              subtitle: _archiveSubtitle(),
              trailing: const Icon(Icons.file_open),
              onTap: () => _selectFile(context),
            ),
            ElevatedButton(
              onPressed: _archive == null ? null : () => _import(context),
              child: const Text('Import data'),
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
      dialogTitle: 'Select archive',
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );
    if (result == null || result.xFiles.isEmpty) return;
    final file = result.xFiles.first;

    final archive = await _importService.loadArchive(file.path);
    if (archive == null) {
      if (!mounted || !context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Cannot open archive'),
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
          ListTile(title: Text('${_archive!.cameras.length} cameras')),
          ListTile(title: Text('${_archive!.lenses.length} lenses')),
          ListTile(title: Text('${_archive!.filters.length} filters')),
          ListTile(title: Text('${_archive!.filmStock.length} film stocks')),
          ListTile(title: Text('${_archive!.films.length} films')),
          ListTile(title: Text('${_countPhotos()} photos')),
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
