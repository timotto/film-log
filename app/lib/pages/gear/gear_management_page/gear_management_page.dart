import 'package:film_log/model/camera.dart';
import 'package:film_log/model/film_stock.dart';
import 'package:film_log/model/filter.dart';
import 'package:film_log/model/lens.dart';
import 'package:film_log/pages/gear/camera/gear_camera_view_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../service/camera_repo.dart';
import '../../../service/filmstock_repo.dart';
import '../../../service/filter_repo.dart';
import '../../../service/lens_repo.dart';
import '../filmstock/gear_filmstock_view_page.dart';
import '../filter/gear_filter_view_page.dart';
import '../lens/gear_lens_view_page.dart';
import 'widgets/gear_list_tile.dart';

class GearManagementPage extends StatelessWidget {
  const GearManagementPage({
    super.key,
    required this.cameraRepo,
    required this.lensRepo,
    required this.filterRepo,
    required this.filmstockRepo,
  });

  final CameraRepo cameraRepo;
  final LensRepo lensRepo;
  final FilterRepo filterRepo;
  final FilmstockRepo filmstockRepo;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).pageTitleGear),
        ),
        body: ListView(
          children: [
            GearListTile(
              label: AppLocalizations.of(context).gearTitleTitleCameras,
              labelEmpty: AppLocalizations.of(context).gearPageEmptyCameras,
              repo: cameraRepo,
              itemPageBuilder: (
                context,
                item, {
                bool? create,
              }) =>
                  GearCameraViewPage(
                item: item,
                repo: cameraRepo,
                create: create,
              ),
              itemCreator: Camera.createNew,
            ),
            GearListTile(
              label: AppLocalizations.of(context).gearTitleTitleLenses,
              labelEmpty: AppLocalizations.of(context).gearPageEmptyLenses,
              repo: lensRepo,
              itemPageBuilder: (
                context,
                item, {
                bool? create,
              }) =>
                  GearLensViewPage(
                item: item,
                repo: lensRepo,
                cameraRepo: cameraRepo,
                create: create,
              ),
              itemCreator: Lens.createNew,
            ),
            GearListTile(
              label: AppLocalizations.of(context).gearTitleTitleFilters,
              labelEmpty: AppLocalizations.of(context).gearPageEmptyFilters,
              repo: filterRepo,
              itemPageBuilder: (
                context,
                item, {
                bool? create,
              }) =>
                  GearFilterViewPage(
                item: item,
                repo: filterRepo,
                lensRepo: lensRepo,
                create: create,
              ),
              itemCreator: Filter.createNew,
            ),
            GearListTile(
              label: AppLocalizations.of(context).gearTitleTitleFilmStock,
              labelEmpty: AppLocalizations.of(context).gearPageEmptyFilmStock,
              repo: filmstockRepo,
              itemPageBuilder: (
                context,
                item, {
                bool? create,
              }) =>
                  GearFilmstockViewPage(
                item: item,
                repo: filmstockRepo,
                create: create,
              ),
              itemCreator: FilmStock.createNew,
            ),
          ],
        ),
      );
}
