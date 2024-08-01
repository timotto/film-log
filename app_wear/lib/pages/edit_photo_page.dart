import 'package:film_log_wear/model/aperture.dart';
import 'package:film_log_wear/model/photo.dart';
import 'package:film_log_wear/model/shutter_speed.dart';
import 'package:film_log_wear/pages/edit_aperture_page.dart';
import 'package:film_log_wear/pages/edit_filters_page.dart';
import 'package:film_log_wear/pages/edit_lens_page.dart';
import 'package:film_log_wear/pages/edit_shutter_speed_page.dart';
import 'package:film_log_wear/service/filter_repo.dart';
import 'package:film_log_wear/service/lens_repo.dart';
import 'package:film_log_wear/widgets/wear_list_tile.dart';
import 'package:film_log_wear/widgets/wear_list_view.dart';
import 'package:flutter/material.dart';

import '../fmt/aperture.dart';
import '../fmt/shutter_speed.dart';
import '../model/film.dart';
import '../model/filter.dart';
import '../model/lens.dart';

class EditPhotoPage extends StatefulWidget {
  const EditPhotoPage({
    super.key,
    required this.film,
    required this.photo,
  });

  final Film film;
  final Photo photo;

  @override
  State<StatefulWidget> createState() => _EditPhotoPageState();
}

class _EditPhotoPageState extends State<EditPhotoPage> {
  late Photo photo;

  final _lensRepo = LensRepo();
  final _filterRepo = FilterRepo();

  @override
  void initState() {
    photo = widget.photo;
    super.initState();
  }

  Future<void> _editShutterSpeed(BuildContext context) async {
    final double? result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => EditShutterSpeedPage(
        value: photo.shutterSpeed,
        values: widget.film.camera?.shutterSpeeds ?? shutterSpeeds(),
      ),
    ));
    if (result == null || !mounted || !context.mounted) return;
    setState(() {
      photo = photo.update(shutterSpeed: result);
    });
  }

  Future<void> _editLens(BuildContext context) async {
    final Lens? result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => EditLensPage(
        value: photo.lens,
        values: _lenses(),
      ),
    ));
    if (result == null || !mounted || !context.mounted) return;
    setState(() {
      photo = photo.update(lens: result);
    });
  }

  Future<void> _editAperture(BuildContext context) async {
    final double? result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => EditAperturePage(
        value: photo.aperture,
        values: photo.lens?.apertures ?? aperturesWhole(),
      ),
    ));
    if (result == null || !mounted || !context.mounted) return;
    setState(() {
      photo = photo.update(aperture: result);
    });
  }

  Future<void> _editFilters(BuildContext context) async {
    final List<Filter>? result =
        await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => EditFiltersPage(
        selected: photo.filters,
        values: _filters(),
      ),
    ));
    if (result == null || !mounted || !context.mounted) return;
    setState(() {
      photo = photo.update(filters: result);
    });
  }

  Future<void> _editLocation(BuildContext context) async {}

  List<Lens> _lenses() => _lensRepo
      .value()
      .where((lens) => lens.cameras
          .where((camera) => camera.id == widget.film.camera?.id)
          .isNotEmpty)
      .toList(growable: false);

  List<Filter> _filters() => _filterRepo
      .value()
      .where((filter) => filter.lenses
          .where((lens) => lens.id == widget.photo.lens?.id)
          .isNotEmpty)
      .toList(growable: false);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: WearListView(
          itemExtend: 64,
          selectedIndex: 1,
          children: [
            _acceptButton(context),
            WearListTile(
              title: 'Shutter speed',
              subtitle: photo.shutterSpeed == null
                  ? null
                  : formatShutterSpeed(photo.shutterSpeed!),
              onTap: () => _editShutterSpeed(context),
            ),
            WearListTile(
              title: 'Lens',
              subtitle: photo.lens?.label,
              onTap: () => _editLens(context),
            ),
            WearListTile(
              title: 'Aperture',
              subtitle: photo.aperture == null
                  ? null
                  : formatAperture(photo.aperture!),
              onTap: () => _editAperture(context),
            ),
            WearListTile(
              title: 'Filters',
              subtitle: photo.filters.isEmpty
                  ? null
                  : photo.filters.map((filter) => filter.label).join(', '),
              onTap: () => _editFilters(context),
            ),
            WearListTile(
              title: 'Location',
              onTap: () => _editLocation(context),
            ),
            _acceptButton(context),
          ],
        ),
      );

  Widget _acceptButton(BuildContext context) => IconButton(
        onPressed: () => Navigator.of(context).pop(photo),
        icon: const Icon(Icons.check),
      );
}
