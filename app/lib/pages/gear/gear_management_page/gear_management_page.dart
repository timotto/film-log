import 'package:film_log/model/camera.dart';
import 'package:film_log/model/film_stock.dart';
import 'package:film_log/model/filter.dart';
import 'package:film_log/model/lens.dart';
import 'package:film_log/pages/gear/camera/gear_camera_view_page.dart';
import 'package:flutter/material.dart';

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
          title: const Text('Gear'),
        ),
        body: ListView(
          children: [
            GearListTile(
              label: 'Cameras',
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
              label: 'Lenses',
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
              label: 'Filters',
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
              label: 'Film stock',
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
