import 'package:film_log/model/film_instance.dart';
import 'package:film_log/model/photo.dart';
import 'package:film_log/pages/edit_film_page/edit_film_page.dart';
import 'package:film_log/pages/edit_photo_page/edit_photo_page.dart';
import 'package:film_log/service/film_repo.dart';
import 'package:film_log/service/repos.dart';
import 'package:film_log/widgets/app_menu.dart';
import 'package:flutter/material.dart';

class FilmLogPage extends StatefulWidget {
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
  State<StatefulWidget> createState() => _FilmLogPageState();
}

class _FilmLogPageState extends State<FilmLogPage> {
  late FilmInstance film;

  @override
  void initState() {
    film = widget.value;
    super.initState();
  }

  Future<void> _editFilm(BuildContext context) async {
    final result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => EditFilmPage(
        repos: widget.repos,
        film: film,
        create: false,
      ),
    ));
    if (result == null) return;
    await widget.repo.update(result);
    if (!mounted || !context.mounted) return;
    setState(() {
      film = result;
    });
  }

  Future<void> _addPhoto(BuildContext context) async {
    final frameNumber = film.photos.length + 1;
    final result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => EditPhotoPage(
        photo: Photo.createNew(
          frameNumber,
        ),
        film: film,
        repos: widget.repos,
        create: true,
      ),
    ));
    if (result == null) return;
    film = film.update(photos: [...film.photos, result]);
    widget.repo.update(film);
    if (!mounted || !context.mounted) return;
    setState(() {});
  }

  Future<void> _archive(BuildContext context) async {
    film = film.update(archive: true);
    await widget.repo.update(film);
    if (!mounted || !context.mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _delete(BuildContext context) async {
    await widget.repo.delete(film);
    if (!mounted || !context.mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _export(BuildContext context) async {}

  Future<void> _selectItem(BuildContext context, Photo photo) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => EditPhotoPage(
        photo: photo,
        film: film,
        repos: widget.repos,
      ),
    ));
  }

  bool _canAddPhoto() =>
      !film.archive && film.photos.length < film.maxPhotoCount;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.value.name),
          actions: [
            IconButton(
              onPressed: () => _editFilm(context),
              icon: const Icon(Icons.edit),
            ),
            AppMenu(
              repos: widget.repos,
              menuItems: [
                MenuItemButton(
                  onPressed: () => _export(context),
                  leadingIcon: const Icon(Icons.send),
                  child: const Text('Export'),
                ),
                if (!film.archive)
                  MenuItemButton(
                    onPressed: () => _archive(context),
                    leadingIcon: const Icon(Icons.archive),
                    child: const Text('Archive'),
                  ),
                MenuItemButton(
                  onPressed: () => _delete(context),
                  leadingIcon: const Icon(Icons.delete),
                  child: const Text('Delete'),
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
            .asMap()
            .map((index, item) => MapEntry(
                index,
                ListTile(
                  title: Text('#${index + 1}'),
                  subtitle: Text(item.listItemSubtitle(
                    context,
                    photos: film.photos,
                  )),
                  onTap: () => _selectItem(context, item),
                )))
            .values
            .toList(growable: false),
      );

  Widget _empty(BuildContext context) => const Center(
        child: Text('There are no photos yet'),
      );
}
