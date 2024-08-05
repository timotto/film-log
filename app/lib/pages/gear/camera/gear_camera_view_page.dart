import 'package:film_log/model/camera.dart';
import 'package:film_log/pages/gear/widgets/filmstock_format_edit_tile.dart';
import 'package:film_log/pages/gear/widgets/gear_view_page.dart';
import 'package:film_log/pages/gear/widgets/shutterspeed_edit_tile.dart';
import 'package:film_log/pages/gear/widgets/text_edit_tile.dart';
import 'package:film_log/service/camera_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GearCameraViewPage extends StatelessWidget {
  const GearCameraViewPage({
    super.key,
    required this.item,
    required this.repo,
    this.create,
  });

  final Camera item;
  final CameraRepo repo;
  final bool? create;

  @override
  Widget build(BuildContext context) => GearViewPage(
        item: item,
        repo: repo,
        create: create,
        tilesBuilder: (context, item, edit, onUpdate) => [
          TextEditTile(
            label: AppLocalizations.of(context).gearTitleTitleName,
            value: item.name,
            edit: edit,
            onUpdate: onUpdate((value) => item.update(name: value)),
          ),
          TextEditTile(
            label: AppLocalizations.of(context).gearTitleTitleManufacturer,
            value: item.manufacturer,
            edit: edit,
            onUpdate: onUpdate((value) => item.update(manufacturer: value)),
          ),
          TextEditTile(
            label: AppLocalizations.of(context).gearTitleTitleProduct,
            value: item.product,
            edit: edit,
            onUpdate: onUpdate((value) => item.update(product: value)),
          ),
          ShutterSpeedEditTile(
            label: AppLocalizations.of(context).gearTitleTitleMinShutterSpeed,
            edit: edit,
            value: item.fastestShutterSpeed,
            max: item.slowestShutterSpeed,
            onUpdate: onUpdate((value) => item.update(
                  fastestShutterSpeed: value,
                )),
          ),
          ShutterSpeedEditTile(
            label: AppLocalizations.of(context).gearTitleTitleMaxShutterSpeed,
            edit: edit,
            value: item.slowestShutterSpeed,
            min: item.fastestShutterSpeed,
            onUpdate: onUpdate((value) => item.update(
                  slowestShutterSpeed: value,
                )),
          ),
          FilmstockFormatEditTile(
            label: AppLocalizations.of(context).gearTitleTitleFilmFormat,
            value: item.filmstockFormat,
            edit: edit,
            onUpdate: onUpdate((value) => item.update(filmstockFormat: value)),
          ),
        ],
      );
}
