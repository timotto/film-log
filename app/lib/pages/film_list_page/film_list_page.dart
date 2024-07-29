import 'package:film_log/model/film_instance.dart';
import 'package:film_log/pages/edit_film_page/edit_film_page.dart';
import 'package:film_log/pages/film_log_page/film_log_page.dart';
import 'package:film_log/service/film_repo.dart';
import 'package:film_log/service/repos.dart';
import 'package:film_log/widgets/app_menu.dart';
import 'package:flutter/material.dart';

class FilmListPage extends StatelessWidget {
  const FilmListPage({
    super.key,
    required this.repo,
    required this.repos,
    this.archive = false,
  });

  final FilmRepo repo;
  final Repos repos;
  final bool archive;

  Future<void> _addFilm(BuildContext context) async {
    final result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => EditFilmPage(
        repos: repos,
        film: FilmInstance.createNew(),
        create: true,
      ),
    ));
    if (result != null) {
      repo.add(result);
    }
  }

  Future<void> _selectFilm(BuildContext context, FilmInstance item) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => FilmLogPage(
        value: item,
        repo: repo,
        repos: repos,
      ),
    ));
  }

  Future<void> _showArchive(BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => FilmListPage(
        repo: repo,
        repos: repos,
        archive: true,
      ),
    ));
  }

  List<FilmInstance> _filter(List<FilmInstance> items) =>
      items.where((item) => item.archive == archive).toList(growable: false);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(archive ? 'Film archive' : 'Films'),
          actions: [
            AppMenu(
              repos: repos,
              menuItems: [
                if (!archive)
                  MenuItemButton(
                    onPressed: () => _showArchive(context),
                    leadingIcon: const Icon(Icons.archive),
                    child: const Text('Film archive'),
                  ),
              ],
            ),
          ],
        ),
        floatingActionButton: archive
            ? null
            : FloatingActionButton(
                onPressed: () => _addFilm(context),
                child: const Icon(Icons.add),
              ),
        body: StreamBuilder(
          stream: repo.itemsStream(),
          initialData: repo.items(),
          builder: (context, items) =>
              _body(context, _filter(items.data ?? [])),
        ),
      );

  Widget _body(BuildContext context, List<FilmInstance> items) =>
      items.isNotEmpty ? _list(context, items) : _empty(context);

  Widget _list(BuildContext context, List<FilmInstance> items) => ListView(
        children: items
            .map((item) => ListTile(
                  title: Text(item.name),
                  subtitle:
                      Text('${item.photos.length} / ${item.maxPhotoCount}'),
                  onTap: () => _selectFilm(context, item),
                ))
            .toList(growable: false),
      );

  Widget _empty(BuildContext context) => const Center(
        child: Text('You don\'t have any Films'),
      );
}
