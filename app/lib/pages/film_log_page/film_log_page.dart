import 'package:film_log/model/film_instance.dart';
import 'package:film_log/model/photo.dart';
import 'package:film_log/pages/edit_film_page/edit_film_page.dart';
import 'package:film_log/pages/edit_photo_page/edit_photo_page.dart';
import 'package:film_log/service/film_repo.dart';
import 'package:film_log/service/lru.dart';
import 'package:film_log/service/repos.dart';
import 'package:film_log/widgets/app_menu.dart';
import 'package:flutter/material.dart';

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

  Widget _loading(BuildContext context) => const Scaffold(
        body: Center(
          child: Text('Loading...'),
        ),
      );

  Widget _notFound(BuildContext context) => const Scaffold(
        body: Center(
          child: Text('Film not found'),
        ),
      );
}
// class FilmLogPage extends StatefulWidget {
//   const FilmLogPage({
//     super.key,
//     required this.value,
//     required this.repo,
//     required this.repos,
//   });
//
//   final FilmInstance value;
//   final FilmRepo repo;
//   final Repos repos;
//
//   @override
//   State<StatefulWidget> createState() => _FilmLogPageState();
// }
//
// class _FilmLogPageState extends State<FilmLogPage> {
//   late FilmInstance film;
//
//   final _lru = LruService();
//
//   @override
//   void initState() {
//     film = widget.value;
//     super.initState();
//   }
//
//   Future<void> _editFilm(BuildContext context) async {
//     final result = await Navigator.of(context).push(MaterialPageRoute(
//       builder: (_) => EditFilmPage(
//         repos: widget.repos,
//         film: film,
//         create: false,
//       ),
//     ));
//     if (result == null) return;
//     await widget.repo.update(result);
//     if (!mounted || !context.mounted) return;
//     setState(() {
//       film = result;
//     });
//   }
//
//   Future<void> _addPhoto(BuildContext context) async {
//     final frameNumber = film.photos.length + 1;
//     final Photo? result = await Navigator.of(context).push(MaterialPageRoute(
//       builder: (_) => EditPhotoPage(
//         photo: Photo.createNew(
//           frameNumber,
//           lens: _lru.lens,
//           shutter: _lru.shutter,
//           aperture: _lru.aperture,
//           filters: _lru.filters,
//         ),
//         film: film,
//         repos: widget.repos,
//         create: true,
//       ),
//     ));
//     if (result == null) return;
//     _lru.setPhoto(
//       lens: result.lens,
//       shutter: result.shutter,
//       aperture: result.aperture,
//       filters: result.filters,
//     );
//     film = film.update(photos: [...film.photos, result]);
//     await widget.repo.update(film);
//     if (!mounted || !context.mounted) return;
//     setState(() {});
//   }
//
//   Future<void> _archive(BuildContext context) async {
//     film = film.update(archive: true);
//     await widget.repo.update(film);
//     if (!mounted || !context.mounted) return;
//     Navigator.of(context).pop();
//   }
//
//   Future<void> _delete(BuildContext context) async {
//     await widget.repo.delete(film);
//     if (!mounted || !context.mounted) return;
//     Navigator.of(context).pop();
//   }
//
//   Future<void> _export(BuildContext context) async {}
//
//   Future<void> _selectItem(BuildContext context, Photo photo) async {
//     await Navigator.of(context).push(MaterialPageRoute(
//       builder: (_) => EditPhotoPage(
//         photo: photo,
//         film: film,
//         repos: widget.repos,
//       ),
//     ));
//     setState(() {});
//   }
//
//   bool _canAddPhoto() =>
//       !film.archive && film.photos.length < film.maxPhotoCount;
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//         appBar: AppBar(
//           title: Text(widget.value.name),
//           actions: [
//             IconButton(
//               onPressed: () => _editFilm(context),
//               icon: const Icon(Icons.edit),
//             ),
//             AppMenu(
//               repos: widget.repos,
//               menuItems: [
//                 MenuItemButton(
//                   onPressed: () => _export(context),
//                   leadingIcon: const Icon(Icons.send),
//                   child: const Text('Export'),
//                 ),
//                 if (!film.archive)
//                   MenuItemButton(
//                     onPressed: () => _archive(context),
//                     leadingIcon: const Icon(Icons.archive),
//                     child: const Text('Archive'),
//                   ),
//                 MenuItemButton(
//                   onPressed: () => _delete(context),
//                   leadingIcon: const Icon(Icons.delete),
//                   child: const Text('Delete'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         floatingActionButton: film.archive
//             ? null
//             : FloatingActionButton(
//                 onPressed: _canAddPhoto() ? () => _addPhoto(context) : null,
//                 child: const Icon(Icons.add),
//               ),
//         body: _body(context),
//       );
//
//   Widget _body(BuildContext context) =>
//       film.photos.isNotEmpty ? _list(context) : _empty(context);
//
//   Widget _list(BuildContext context) => ListView(
//         children: film.photos
//             .map((item) => _photoListTile(context, item))
//             .toList(growable: false),
//       );
//
//   Widget _empty(BuildContext context) => const Center(
//         child: Text('There are no photos yet'),
//       );
//
//   Widget _photoListTile(BuildContext context, Photo item) => ListTile(
//         title: Text('#${item.frameNumber}'),
//         subtitle: Text(item.listItemSubtitle(
//           context,
//           photos: film.photos,
//         )),
//         leading: item.thumbnail != null
//             ? Image(
//                 image: ResizeImage(
//                   FileImage(widget.repos.thumbnailRepo.file(item.thumbnail!)),
//                   width: 64,
//                 ),
//               )
//             : null,
//         onTap: () => _selectItem(context, item),
//       );
// }

class _FilmLogPageWidget extends StatelessWidget {
  _FilmLogPageWidget({
    required this.film,
    required this.repo,
    required this.repos,
  });

  final FilmInstance film;
  final FilmRepo repo;
  final Repos repos;

  final _lru = LruService();

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
    final frameNumber = film.photos.length + 1;
    final Photo? result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => EditPhotoPage(
        photo: Photo.createNew(
          frameNumber,
          lens: _lru.lens,
          shutter: _lru.shutter,
          aperture: _lru.aperture,
          filters: _lru.filters,
        ),
        film: film,
        repos: repos,
        create: true,
      ),
    ));
    if (result == null) return;
    _lru.setPhoto(
      lens: result.lens,
      shutter: result.shutter,
      aperture: result.aperture,
      filters: result.filters,
    );
    await repo.update(film.update(photos: [...film.photos, result]));
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

  Future<void> _export(BuildContext context) async {}

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
            .map((item) => _photoListTile(context, item))
            .toList(growable: false),
      );

  Widget _empty(BuildContext context) => const Center(
        child: Text('There are no photos yet'),
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
