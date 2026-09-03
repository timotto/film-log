import 'package:film_log/model/film_instance.dart';
import 'package:film_log/model/photo.dart';
import 'package:film_log/model/sort.dart';
import 'package:film_log/pages/edit_film_page/edit_film_page.dart';
import 'package:film_log/pages/film_log_page/film_log_page.dart';
import 'package:film_log/pages/manage_data_page/manage_data_page.dart';
import 'package:film_log/service/film_repo.dart';
import 'package:film_log/service/lru.dart';
import 'package:film_log/service/repos.dart';
import 'package:film_log/widgets/app_menu.dart';
import 'package:film_log/widgets/film_sort_menu.dart';
import 'package:film_log_wear_data/common/suggest_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilmListPage extends StatefulWidget {
  FilmListPage({
    super.key,
    required this.repo,
    required this.repos,
    this.archive = false,
  });

  final FilmRepo repo;
  final Repos repos;
  final bool archive;

  @override
  State<StatefulWidget> createState() => FilmListPageState();
}

class FilmListPageState extends State<FilmListPage> {
  final _lru = LruService();

  FilmSortOrder sortOrder = FilmSortOrder.lastPhoto;
  SortOrderDirection sortDirection = SortOrderDirection.descending;

  void _updateSortOrder(FilmSortOrder order, SortOrderDirection direction) =>
      setState(() {
        sortOrder = order;
        sortDirection = direction;
      });

  Future<void> _addFilm(BuildContext context) async {
    final FilmInstance? result =
        await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => EditFilmPage(
        repos: widget.repos,
        film: FilmInstance.createNew(
          name: _suggestNextFilmName(),
          camera: _lru.camera,
          filmStock: _lru.filmStock,
          actualIso: _lru.filmStock?.iso,
          maxPhotoCount: _lru.maxPhotoCount,
        ),
        create: true,
      ),
    ));
    if (result == null) return;

    _lru.setFilm(
      camera: result.camera,
      filmStock: result.stock,
      maxPhotoCount: result.maxPhotoCount,
    );

    final item = await widget.repo.add(result);
    if (!context.mounted) return;
    await _selectFilm(context, item);
  }

  Future<void> _selectFilm(BuildContext context, FilmInstance item) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => FilmLogPage(
        value: item,
        repo: widget.repo,
        repos: widget.repos,
      ),
    ));
  }

  Future<void> _showArchive(BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => FilmListPage(
        repo: widget.repo,
        repos: widget.repos,
        archive: true,
      ),
    ));
  }

  Future<void> _manageData(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ManageDataPage(repos: widget.repos),
      ),
    );
  }

  List<FilmInstance> _filter(List<FilmInstance> items) => items
      .where((item) => item.archive == widget.archive)
      .toList(growable: false);

  List<FilmInstance> _sort(List<FilmInstance> items) {
    items.sort(_sortFnFor(sortOrder));
    return _flipOrderWhenDescending(sortDirection, items);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            widget.archive
                ? AppLocalizations.of(context).pageTitleFilmInstanceListArchive
                : AppLocalizations.of(context).pageTitleFilmInstanceList,
          ),
          actions: [
            FilmSortMenu(
              order: sortOrder,
              direction: sortDirection,
              onUpdate: _updateSortOrder,
            ),
            AppMenu(
              repos: widget.repos,
              menuItems: [
                if (!widget.archive)
                  MenuItemButton(
                    onPressed: () => _showArchive(context),
                    leadingIcon: const Icon(Icons.archive),
                    child: Text(
                      AppLocalizations.of(context).menuItemFilmInstanceArchive,
                    ),
                  ),
                MenuItemButton(
                  onPressed: () => _manageData(context),
                  leadingIcon: const Icon(Icons.file_copy),
                  child: Text(AppLocalizations.of(context).menuItemManageData),
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: widget.archive
            ? null
            : FloatingActionButton(
                onPressed: () => _addFilm(context),
                child: const Icon(Icons.add),
              ),
        body: StreamBuilder(
          stream: widget.repo.itemsStream(),
          initialData: widget.repo.items(),
          builder: (context, items) =>
              _body(context, items.data ?? []),
        ),
      );

  Widget _body(BuildContext context, List<FilmInstance> items) =>
      items.isNotEmpty ? _list(context, _sort(_filter(items))) : _empty(context);

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

  Widget _empty(BuildContext context) => Center(
        child: Text(
          widget.archive
              ? AppLocalizations.of(context).filmInstanceListArchiveEmpty
              : AppLocalizations.of(context).filmInstanceListEmpty,
        ),
      );

  String _suggestNextFilmName() {
    if (widget.repos.filmRepo.itemsList.isEmpty) return '';

    var latest = widget.repos.filmRepo.itemsList.reduce((a, b) {
      if (a.inserted.isAfter(b.inserted)) {
        return a;
      } else {
        return b;
      }
    });

    return suggestNextFilmName(previousFilmName: latest.name, fallbackName: '');
  }
}

int Function(FilmInstance a, FilmInstance b) _sortFnFor(FilmSortOrder order) {
  switch (order) {
    case FilmSortOrder.label:
      return _sortByLabel;
    case FilmSortOrder.inserted:
      return _sortByInserted;
    case FilmSortOrder.lastPhoto:
      return _sortByLastPhoto;
  }
}

int _sortByLabel(FilmInstance a, FilmInstance b) => a.name.compareTo(b.name);

int _sortByInserted(FilmInstance a, FilmInstance b) =>
    a.inserted.compareTo(b.inserted);

int _sortByLastPhoto(FilmInstance a, FilmInstance b) {
  var la = _latestPhotoOf(a);
  var lb = _latestPhotoOf(b);
  if (la != null && lb == null) return -1;
  if (la == null && lb != null) return 1;
  if (la == null && lb == null) return 0;
  return la!.timestamp.compareTo(lb!.timestamp);
}

Photo? _latestPhotoOf(FilmInstance film) => film.photos.isEmpty
    ? null
    : film.photos.reduce((a, b) => a.timestamp.isAfter(b.timestamp) ? a : b);

List<FilmInstance> _flipOrderWhenDescending(
        SortOrderDirection direction, List<FilmInstance> items) =>
    direction == SortOrderDirection.ascending ? items : items.reversed.toList();
