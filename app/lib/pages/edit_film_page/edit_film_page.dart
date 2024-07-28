import 'package:film_log/model/film_instance.dart';
import 'package:film_log/pages/gear/widgets/camera_edit_tile.dart';
import 'package:film_log/pages/gear/widgets/double_edit_tile.dart';
import 'package:film_log/pages/gear/widgets/filmstock_edit_tile.dart';
import 'package:film_log/pages/gear/widgets/text_edit_tile.dart';
import 'package:film_log/service/repos.dart';
import 'package:film_log/widgets/timestamp_list_tile.dart';
import 'package:flutter/material.dart';

class EditFilmPage extends StatefulWidget {
  const EditFilmPage({
    super.key,
    required this.repos,
    required this.film,
    this.create = false,
  });

  final FilmInstance film;
  final Repos repos;
  final bool create;

  @override
  State<StatefulWidget> createState() => _EditFilmPageState();
}

class _EditFilmPageState extends State<EditFilmPage> {
  late FilmInstance film;

  @override
  void initState() {
    film = widget.film;
    super.initState();
  }

  Future<void> _save(BuildContext context) async {
    Navigator.of(context).pop(film);
  }

  Function(T) _onUpdate<T>(FilmInstance Function(T) fn) =>
      (value) => setState(() => film = fn(value));

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.create ? 'Add film' : 'Edit film'),
          actions: [
            IconButton(
              onPressed: film.validate() ? () => _save(context) : null,
              icon: const Icon(Icons.check),
            ),
          ],
        ),
        body: ListView(
          children: [
            TextEditTile(
              label: 'Name',
              value: film.name,
              edit: true,
              onUpdate: _onUpdate((value) => film.update(name: value)),
            ),
            TimestampListTile(
              label: 'Inserted',
              value: film.inserted,
              edit: true,
              onUpdate: _onUpdate((value) => film.update(inserted: value)),
            ),
            CameraEditTile(
              label: 'Camera',
              value: film.camera,
              repo: widget.repos.cameraRepo,
              edit: true,
              onUpdate: _onUpdate((value) => film.update(camera: value)),
            ),
            FilmstockEditTile(
              label: 'Film stock',
              value: film.stock,
              repo: widget.repos.filmstockRepo,
              format: film.camera?.filmstockFormat,
              edit: true,
              onUpdate: _onUpdate((value) => film.update(
                    stock: value,
                    actualIso: value?.iso,
                  )),
            ),
            DoubleEditTile(
              label: 'Actual iso',
              value: film.actualIso,
              edit: true,
              valueToString: (v) => v.toStringAsFixed(0),
              stringToValue: double.tryParse,
              onUpdate: _onUpdate((value) => film.update(actualIso: value)),
            ),
            DoubleEditTile(
              label: 'Frames',
              value: film.maxPhotoCount.toDouble(),
              edit: true,
              valueToString: (v) => v.toStringAsFixed(0),
              stringToValue: double.tryParse,
              onUpdate: _onUpdate(
                (value) => film.update(maxPhotoCount: value.toInt()),
              ),
            ),
          ],
        ),
      );
}
