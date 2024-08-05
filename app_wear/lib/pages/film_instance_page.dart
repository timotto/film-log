import 'package:film_log_wear/model/film.dart';
import 'package:film_log_wear/model/photo.dart';
import 'package:film_log_wear/pages/edit_photo_page.dart';
import 'package:film_log_wear/service/film_repo.dart';
import 'package:film_log_wear/service/wear_data.dart';
import 'package:film_log_wear/widgets/swipe_dismiss.dart';
import 'package:film_log_wear/widgets/wear_list_tile.dart';
import 'package:film_log_wear/widgets/wear_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:uuid/v4.dart';

class FilmInstancePage extends StatelessWidget {
  FilmInstancePage({super.key, required this.filmId});

  final _repo = FilmRepo();
  final String filmId;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SwipeDismiss(
          child: StreamBuilder(
            stream: _repo.itemStream(filmId),
            initialData: _repo.item(filmId),
            builder: (context, film) {
              if (!film.hasData) {
                return _loading(context);
              }
              if (film.data == null) {
                return _notFound(context);
              }
              return _content(context, film.data!);
            },
          ),
        ),
      );

  Widget _content(BuildContext context, Film film) =>
      _FilmInstancePageWidget(film: film);

  Widget _loading(BuildContext context) => Center(
        child: Text(AppLocalizations.of(context).filmInstanceLoading),
      );

  Widget _notFound(BuildContext context) => Center(
        child: Text(AppLocalizations.of(context).filmInstanceFilmNotFound),
      );
}

class _FilmInstancePageWidget extends StatefulWidget {
  const _FilmInstancePageWidget({required this.film});

  final Film film;

  @override
  State<StatefulWidget> createState() => _FilmInstancePageState();
}

class _FilmInstancePageState extends State<_FilmInstancePageWidget> {
  final double itemExtend = 48;

  final _listKey = GlobalKey();

  final _wearData = WearDataService();

  final _repo = FilmRepo();

  late final ScrollController _controller;

  int _lastCount = 0;
  bool _scroll = false;

  @override
  void initState() {
    _controller = ScrollController(
      initialScrollOffset: itemExtend * widget.film.photos.length,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _maybeScrollToEnd() {
    if (!_scroll) return;
    if (widget.film.photos.length == _lastCount) return;
    _scroll = false;
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
  }

  void _scrollToEnd() {
    final double offset = itemExtend * widget.film.photos.length;
    _controller.animateTo(
      offset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    _maybeScrollToEnd();

    return WearListView(
      controller: _controller,
      key: _listKey,
      itemExtend: itemExtend,
      children: _children(context),
    );
  }

  List<Widget> _children(BuildContext context) => [
        ...widget.film.photos.map((item) => _itemTile(context, item)),
        if (widget.film.canAddPhoto()) _addButton(context),
      ];

  Widget _itemTile(BuildContext context, Photo item) => WearListTile(
        title: '#${item.frameNumber}',
        subtitle: item.listItemSubTitle(),
        onTap: () => _show(context, item),
      );

  Widget _addButton(BuildContext context) => IconButton(
        onPressed: () => _add(context),
        icon: const Icon(Icons.add),
      );

  Future<void> _add(BuildContext context) async {
    final Photo? result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => EditPhotoPage(
        film: widget.film,
        photo: _nextPhoto(),
        edit: true,
      ),
    ));

    if (result == null || !mounted || !context.mounted) return;
    _lastCount = widget.film.photos.length;
    _scroll = true;

    final film = widget.film.addPhoto(result);
    _repo.update(film);
    _wearData.sendPhoto(
      photo: result,
      film: widget.film,
    );
  }

  Future<void> _show(BuildContext context, Photo item) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => EditPhotoPage(
        film: widget.film,
        photo: item,
        edit: false,
      ),
    ));
  }

  Photo _nextPhoto() {
    Photo? lastPhoto = widget.film.photos.lastOrNull;
    return Photo(
      id: const UuidV4().generate(),
      frameNumber: widget.film.photos.length + 1,
      recorded: DateTime.timestamp(),
      filters: lastPhoto == null ? [] : [...lastPhoto.filters],
      lens: lastPhoto?.lens,
      aperture: lastPhoto?.aperture,
      shutterSpeed: lastPhoto?.shutterSpeed,
      location: null,
    );
  }
}
