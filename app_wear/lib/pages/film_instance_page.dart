import 'package:film_log_wear/model/film.dart';
import 'package:film_log_wear/model/photo.dart';
import 'package:film_log_wear/pages/edit_photo_page.dart';
import 'package:film_log_wear/service/wear_data.dart';
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
  final _wearData = WearDataService();

  late Film film;

  @override
  void initState() {
    film = widget.film;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: WearListView(
          children: _children(context),
        ),
      );

  List<Widget> _children(BuildContext context) => [
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        _addButton(context),
        ...film.photos.map((item) => WearListTile(
              title: '#${item.frameNumber}',
            )),
        if (film.photos.isNotEmpty) _addButton(context),
      ];

  Widget _addButton(BuildContext context) => IconButton(
        onPressed: () => _add(context),
        icon: const Icon(Icons.add),
      );

  Future<void> _add(BuildContext context) async {
    final Photo? result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => EditPhotoPage(
        film: film,
        photo: Photo(
          id: '',
          frameNumber: film.photos.length + 1,
          recorded: DateTime.timestamp(),
          filters: [],
          lens: null,
          aperture: null,
          shutterSpeed: null,
          location: null,
        ),
      ),
    ));

    if (result == null || !mounted || !context.mounted) return;
    film = film.addPhoto(result);
    _wearData.sendPhoto(
      photo: result,
      film: widget.film,
    );
    setState(() {});
  }
}
