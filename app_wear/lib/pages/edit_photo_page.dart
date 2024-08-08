import 'package:film_log_wear/model/aperture.dart';
import 'package:film_log_wear/model/item.dart';
import 'package:film_log_wear/model/location.dart';
import 'package:film_log_wear/model/photo.dart';
import 'package:film_log_wear/model/shutter_speed.dart';
import 'package:film_log_wear/pages/edit_aperture_page.dart';
import 'package:film_log_wear/pages/edit_filters_page.dart';
import 'package:film_log_wear/pages/edit_lens_page.dart';
import 'package:film_log_wear/pages/edit_shutter_speed_page.dart';
import 'package:film_log_wear/service/filter_repo.dart';
import 'package:film_log_wear/service/lens_repo.dart';
import 'package:film_log_wear/service/location.dart';
import 'package:film_log_wear/widgets/accept_button.dart';
import 'package:film_log_wear/widgets/swipe_dismiss.dart';
import 'package:film_log_wear/widgets/wear_list_tile.dart';
import 'package:film_log_wear/widgets/wear_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../fmt/aperture.dart';
import '../fmt/shutter_speed.dart';
import '../fmt/timestamp.dart';
import '../model/film.dart';
import '../model/filter.dart';
import '../model/lens.dart';

class EditPhotoPage extends StatefulWidget {
  const EditPhotoPage({
    super.key,
    required this.film,
    required this.photo,
    required this.edit,
  });

  final Film film;
  final Photo photo;
  final bool edit;

  @override
  State<StatefulWidget> createState() => _EditPhotoPageState();
}

class _EditPhotoPageState extends State<EditPhotoPage> {
  final _listKey = GlobalKey();

  late Photo photo;

  final _lensRepo = LensRepo();
  final _filterRepo = FilterRepo();

  @override
  void initState() {
    photo = widget.photo;
    if (widget.edit) {
      _requestLocation();
    }
    super.initState();
  }

  void _onLocation(Location? value) {
    print('edit-photo-page::on-location ${value?.listItemSubtitle()}');
    if (!mounted) return;
    if (value == null) return;
    setState(() {
      photo = photo.update(location: value);
    });
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
      final filtersToKeep = photo.filters
          .where((filter) => contains(filter.lenses, result))
          .toList(growable: false);
      photo = photo.update(
        lens: result,
        filters: filtersToKeep,
      );
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

  Future<void> _editLocation(BuildContext context) async => _requestLocation();

  Future<void> _openLocation(BuildContext context) async =>
      openLocation(context, photo.location!);

  List<Lens> _lenses() => _lensRepo
      .value()
      .where((lens) => lens.cameras
          .where((camera) => camera.id == widget.film.camera?.id)
          .isNotEmpty)
      .toList(growable: false);

  List<Filter> _filters() => _filterRepo
      .value()
      .where((filter) =>
          filter.lenses.where((lens) => lens.id == photo.lens?.id).isNotEmpty)
      .toList(growable: false);

  Iterable<DateTime> _allTimestamps() =>
      widget.film.photos.map((photo) => photo.recorded);

  Future<void> _requestLocation() async {
    final result = await getLocation();
    _onLocation(result);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SwipeDismiss(
          child: WearListView(
            // without this key the scroll position is lost on setState
            key: _listKey,
            itemExtend: 64,
            selectedIndex: 1,
            children: [
              // _acceptButton(context),
              WearListTile(
                title:
                    AppLocalizations.of(context).editPhotoTileTitleFrameNumber,
                subtitle: '#${photo.frameNumber}',
              ),
              if (_ifEditOrNotNull(photo.shutterSpeed))
                WearListTile(
                  title: AppLocalizations.of(context)
                      .editPhotoTileTitleShutterSpeed,
                  subtitle: photo.shutterSpeed == null
                      ? null
                      : formatShutterSpeed(photo.shutterSpeed!),
                  onTap: _ifEdit(() => _editShutterSpeed(context)),
                ),
              if (_ifEditOrNotNull(photo.lens))
                WearListTile(
                  title: AppLocalizations.of(context).editPhotoTileTitleLens,
                  subtitle: photo.lens?.label,
                  onTap: _ifEdit(() => _editLens(context)),
                ),
              if (_ifEditOrNotNull(photo.aperture))
                WearListTile(
                  title:
                      AppLocalizations.of(context).editPhotoTileTitleAperture,
                  subtitle: photo.aperture == null
                      ? null
                      : formatAperture(photo.aperture!),
                  onTap: _ifEdit(() => _editAperture(context)),
                ),
              if ((widget.edit && _filters().isNotEmpty) ||
                  (photo.filters.isNotEmpty))
                WearListTile(
                  title: AppLocalizations.of(context).editPhotoTileTitleFilters,
                  subtitle: photo.filters.isEmpty
                      ? null
                      : photo.filters.map((filter) => filter.label).join(', '),
                  onTap: _ifEdit(() => _editFilters(context)),
                ),
              if (!widget.edit)
                WearListTile(
                  title:
                      AppLocalizations.of(context).editPhotoTileTitleTimestamp,
                  subtitle: formatTimestamp(
                    context,
                    photo.recorded,
                    others: _allTimestamps(),
                  ),
                ),
              if (_ifEditOrNotNull(photo.location))
                WearListTile(
                  title:
                      AppLocalizations.of(context).editPhotoTileTitleLocation,
                  subtitle: photo.location?.listItemSubtitle(),
                  onTap: widget.edit
                      ? () => _editLocation(context)
                      : () => _openLocation(context),
                ),
              if (widget.edit) _acceptButton(context),
            ],
          ),
        ),
      );

  Widget _acceptButton(BuildContext context) => AcceptButton(
        onPressed: () => Navigator.of(context).pop(photo),
      );

  VoidCallback? _ifEdit(VoidCallback cb) => widget.edit ? cb : null;

  bool _ifEditOrNotNull<T>(T? item) => widget.edit || item != null;
}
