import 'package:film_log/model/film_instance.dart';
import 'package:film_log/model/photo.dart';
import 'package:film_log/pages/edit_film_page/edit_film_page.dart';
import 'package:film_log/pages/edit_photo_page/edit_photo_page.dart';
import 'package:film_log/service/export.dart';
import 'package:film_log/service/film_repo.dart';
import 'package:film_log/service/repos.dart';
import 'package:film_log/widgets/app_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

class FilmLogPage extends StatelessWidget {
  const FilmLogPage({
    super.key,
    required this.value,
    required this.repo,
    required this.repos,
  });

  final FilmInstance value;
  final FilmRepo repo;
  final Repos repos;

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: repo.itemStream(value.id),
        initialData: repo.item(value.id),
        builder: (context, film) {
          if (!film.hasData) {
            return _loading(context);
          }
          if (film.data == null) {
            return _notFound(context);
          }
          return _page(context, film.data!);
        },
      );

  Widget _page(BuildContext context, FilmInstance film) => _FilmLogPageWidget(
        film: film,
        repo: repo,
        repos: repos,
      );

  Widget _loading(BuildContext context) => Scaffold(
        body: Center(
          child: Text(AppLocalizations.of(context).filmLogPageLoading),
        ),
      );

  Widget _notFound(BuildContext context) => Scaffold(
        body: Center(
          child: Text(AppLocalizations.of(context).filmLogPageFilmNotFound),
        ),
      );
}

class _FilmLogPageWidget extends StatelessWidget {
  _FilmLogPageWidget({
    required this.film,
    required this.repo,
    required this.repos,
  });

  final FilmInstance film;
  final FilmRepo repo;
  final Repos repos;

  Future<void> _editFilm(BuildContext context) async {
    final result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => EditFilmPage(
        repos: repos,
        film: film,
        create: false,
      ),
    ));
    if (result == null) return;
    await repo.update(result);
    if (!context.mounted) return;
  }

  Future<void> _addPhoto(BuildContext context) async {
    final lastPhoto = film.photos.lastOrNull;

    final frameNumber = film.photos.length + 1;
    final Photo? result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => EditPhotoPage(
        photo: Photo.createNew(
          frameNumber,
          lens: lastPhoto?.lens,
          shutter: lastPhoto?.shutter,
          aperture: lastPhoto?.aperture,
          filters: lastPhoto?.filters,
        ),
        film: film,
        repos: repos,
        create: true,
      ),
    ));

    if (result == null) return;

    await repo.update(film.addPhoto(result));
  }

  Future<void> _archive(BuildContext context) async {
    await repo.update(film.update(archive: true));
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _delete(BuildContext context) async {
    await repo.delete(film);
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _export(BuildContext context) async {
    ExportService(repos: repos).exportFilm(film, (filename) async {
      await Share.shareXFiles(
        [XFile(filename)],
        text: AppLocalizations.of(context).filmLogPageExportActionText,
      );
    });
  }

  Future<void> _selectItem(BuildContext context, Photo photo) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => EditPhotoPage(
        photo: photo,
        film: film,
        repos: repos,
      ),
    ));
  }

  bool _canAddPhoto() =>
      !film.archive && film.photos.length < film.maxPhotoCount;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(film.name),
          actions: [
            IconButton(
              onPressed: () => _editFilm(context),
              icon: const Icon(Icons.edit),
            ),
            AppMenu(
              repos: repos,
              menuItems: [
                MenuItemButton(
                  onPressed: () => _export(context),
                  leadingIcon: const Icon(Icons.send),
                  child: Text(AppLocalizations.of(context).menuItemManageExport),
                ),
                if (!film.archive)
                  MenuItemButton(
                    onPressed: () => _archive(context),
                    leadingIcon: const Icon(Icons.archive),
                    child: Text(AppLocalizations.of(context).menuItemManageArchive),
                  ),
                MenuItemButton(
                  onPressed: () => _delete(context),
                  leadingIcon: const Icon(Icons.delete),
                  child: Text(AppLocalizations.of(context).menuItemManageDelete),
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: film.archive
            ? null
            : FloatingActionButton(
                onPressed: _canAddPhoto() ? () => _addPhoto(context) : null,
                child: const Icon(Icons.add),
              ),
        body: _body(context),
      );

  Widget _body(BuildContext context) =>
      film.photos.isNotEmpty ? _list(context) : _empty(context);

  Widget _list(BuildContext context) => ListView(
        children: film.photos
            .map((item) => _photoListTile(context, item))
            .toList(growable: false),
      );

  Widget _empty(BuildContext context) =>  Center(
        child: Text(AppLocalizations.of(context).filmLogPageNoPhotos),
      );

  Widget _photoListTile(BuildContext context, Photo item) => ListTile(
        title: Text('#${item.frameNumber}'),
        subtitle: Text(item.listItemSubtitle(
          context,
          photos: film.photos,
        )),
        leading: item.thumbnail != null
            ? Image(
                image: ResizeImage(
                  FileImage(repos.thumbnailRepo.file(item.thumbnail!)),
                  width: 64,
                ),
              )
            : null,
        onTap: () => _selectItem(context, item),
      );
}
