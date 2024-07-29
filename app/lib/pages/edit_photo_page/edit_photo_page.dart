import 'package:film_log/model/film_instance.dart';
import 'package:film_log/model/filter.dart';
import 'package:film_log/model/fstop.dart';
import 'package:film_log/model/location.dart';
import 'package:film_log/model/photo.dart';
import 'package:film_log/pages/gear/widgets/aperture_edit_tile.dart';
import 'package:film_log/pages/gear/widgets/lens_edit_tile.dart';
import 'package:film_log/pages/gear/widgets/multiselect_edit_tile.dart';
import 'package:film_log/pages/gear/widgets/shutterspeed_edit_tile.dart';
import 'package:film_log/pages/gear/widgets/text_edit_tile.dart';
import 'package:film_log/service/location.dart';
import 'package:film_log/service/repos.dart';
import 'package:film_log/widgets/location_list_tile.dart';
import 'package:film_log/widgets/thumbnail_list_tile.dart';
import 'package:film_log/widgets/timestamp_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditPhotoPage extends StatefulWidget {
  const EditPhotoPage({
    super.key,
    required this.photo,
    required this.film,
    required this.repos,
    this.create = false,
  });

  final Photo photo;
  final FilmInstance film;
  final Repos repos;
  final bool create;

  @override
  State<StatefulWidget> createState() => _EditPhotoPageState();
}

class _EditPhotoPageState extends State<EditPhotoPage> {
  late Photo photo;
  bool edit = false;

  @override
  void initState() {
    photo = widget.photo;
    if (widget.create) {
      edit = true;
      getLocation().then(_onLocation);
    }
    super.initState();
  }

  void _onLocation(Location? value) {
    if (value == null) {
      return;
    }
    photo = photo.update(location: value);
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _save(BuildContext context) async {
    if (widget.create) {
      Navigator.of(context).pop(photo);
      return;
    }

    if (widget.photo.thumbnail != null) {
      bool photoChanged = false;
      if (photo.thumbnail != null) {
        if (!widget.photo.thumbnail!.equals(photo.thumbnail!)) {
          photoChanged = true;
        }
      } else {
        photoChanged = true;
      }
      if (photoChanged) {
        await widget.repos.thumbnailRepo.delete(widget.photo.thumbnail!);
      }
    }

    print('save photo');
    print('old item:');
    print(widget.photo.toJson());
    print('new item:');
    print(photo.toJson());
    widget.film.photos.removeWhere((item) => item.id == photo.id);
    widget.film.photos.add(photo);
    widget.film.photos.sort((a, b) => a.frameNumber.compareTo(b.frameNumber));
    await widget.repos.filmRepo.update(widget.film);
    setState(() {
      edit = false;
    });
  }

  void _toggleEdit() => setState(() => edit = true);

  bool Function(Filter)? _filterFilter() => photo.lens == null
      ? null
      : (filter) =>
          filter.lenses.isEmpty ||
          filter.lenses.where((item) => item.id == photo.lens?.id).isNotEmpty;

  void Function(T) _onUpdate<T>(Photo Function(T) fn) =>
      (value) => setState(() => photo = fn(value));

  bool _show<T>(T? value) => edit || value != null;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.create ? 'Add photo' : 'Edit photo'),
          actions: [
            if (!edit)
              IconButton(
                onPressed: _toggleEdit,
                icon: const Icon(Icons.edit),
              ),
            if (edit)
              IconButton(
                onPressed: () => _save(context),
                icon: const Icon(Icons.check),
              ),
          ],
        ),
        body: ListView(
          children: [
            _timestampEditTile(context),
            if (_show(photo.shutter)) _shutterSpeedEditTile(context),
            if (_show(photo.lens)) _lensEditTile(context),
            if (_show(photo.aperture)) _apertureEditTile(context),
            if (edit || photo.filters.isNotEmpty) _filtersEditTile(context),
            if (_show(photo.location)) _locationEditTile(context),
            if (edit || (photo.notes?.isNotEmpty ?? false))
              _notesEditTile(context),
            if (_show(photo.thumbnail)) _thumbnailEditTile(context),
          ],
        ),
      );

  Widget _timestampEditTile(BuildContext context) => TimestampListTile(
        label: 'Timestamp',
        value: photo.timestamp,
        edit: edit,
        onUpdate: _onUpdate((value) => photo.update(timestamp: value)),
      );

  Widget _shutterSpeedEditTile(BuildContext context) => ShutterSpeedEditTile(
        label: 'Shutter speed',
        edit: edit,
        value: photo.shutter,
        min: widget.film.camera?.fastestShutterSpeed,
        max: widget.film.camera?.slowestShutterSpeed,
        onUpdate: _onUpdate((value) => photo.update(shutter: value)),
      );

  Widget _lensEditTile(BuildContext context) => LensEditTile(
        label: 'Lens',
        value: photo.lens,
        camera: widget.film.camera,
        repo: widget.repos.lensRepo,
        edit: edit,
        onUpdate: _onUpdate((value) => photo.update(lens: value)),
      );

  Widget _apertureEditTile(BuildContext context) => ApertureEditTile(
        label: 'Aperture',
        edit: edit,
        value: photo.aperture,
        min: photo.lens?.apertureMin,
        max: photo.lens?.apertureMax,
        increments: photo.lens?.fStopIncrements ?? FStopIncrements.full,
        onUpdate: _onUpdate((value) => photo.update(aperture: value)),
      );

  Widget _filtersEditTile(BuildContext context) => MultiselectEditTile(
        label: 'Filters',
        values: photo.filters,
        repo: widget.repos.filterRepo,
        edit: edit,
        onUpdate: _onUpdate<List<Filter>>((value) => photo.update(
              filters: value,
            )),
        filter: _filterFilter(),
      );

  Widget _locationEditTile(BuildContext context) => LocationListTile(
        label: 'Location',
        value: photo.location,
        edit: edit,
        onUpdate: _onUpdate((value) => photo.updateLocation(value)),
      );

  Widget _notesEditTile(BuildContext context) => TextEditTile(
        label: 'Notes',
        value: photo.notes ?? '',
        edit: edit,
        multiline: true,
        onUpdate: _onUpdate((value) => photo.update(
              notes: value.isNotEmpty ? value : null,
            )),
      );

  Widget _thumbnailEditTile(BuildContext context) => ThumbnailListTile(
        label: 'Thumbnail',
        edit: edit,
        value: photo.thumbnail,
        repo: widget.repos.thumbnailRepo,
        onUpdate: _onUpdate((value) => photo.updateThumbnail(value)),
      );
}
