import 'package:film_log_wear/model/film.dart';
import 'package:film_log_wear/model/photo.dart';
import 'package:film_log_wear/pages/edit_photo_page.dart';
import 'package:film_log_wear/service/wear_data.dart';
import 'package:film_log_wear/widgets/swipe_dismiss.dart';
import 'package:film_log_wear/widgets/wear_list_tile.dart';
import 'package:film_log_wear/widgets/wear_list_view.dart';
import 'package:flutter/material.dart';

class FilmInstancePage extends StatefulWidget {
  const FilmInstancePage({super.key, required this.film});

  final Film film;

  @override
  State<StatefulWidget> createState() => _FilmInstancePageState();
}

class _FilmInstancePageState extends State<FilmInstancePage> {
  final double itemExtend = 48;

  final _listKey = GlobalKey();

  final _wearData = WearDataService();

  late final ScrollController _controller;

  late Film film;

  @override
  void initState() {
    film = widget.film;
    _controller = ScrollController(
      initialScrollOffset: itemExtend * film.photos.length,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    final double offset = itemExtend * film.photos.length;
    _controller.jumpTo(offset);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SwipeDismiss(
          child: WearListView(
            controller: _controller,
            key: _listKey,
            itemExtend: itemExtend,
            children: _children(context),
          ),
        ),
      );

  List<Widget> _children(BuildContext context) => [
        ...film.photos.map((item) => _itemTile(context, item)),
        _addButton(context),
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
        film: film,
        photo: _nextPhoto(),
        edit: true,
      ),
    ));

    if (result == null || !mounted || !context.mounted) return;
    setState(() {
      film = film.addPhoto(result);
    });
    _scrollToEnd();
    _wearData.sendPhoto(
      photo: result,
      film: widget.film,
    );
  }

  Future<void> _show(BuildContext context, Photo item) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => EditPhotoPage(
        film: film,
        photo: item,
        edit: false,
      ),
    ));
  }

  Photo _nextPhoto() {
    Photo? lastPhoto = film.photos.lastOrNull;
    return Photo(
      id: '',
      frameNumber: film.photos.length + 1,
      recorded: DateTime.timestamp(),
      filters: lastPhoto == null ? [] : [...lastPhoto.filters],
      lens: lastPhoto?.lens,
      aperture: lastPhoto?.aperture,
      shutterSpeed: lastPhoto?.shutterSpeed,
      location: null,
    );
  }
}
