import 'package:film_log/fmt/shutterspeed.dart';
import 'package:film_log/model/camera.dart';
import 'package:film_log/pages/gear/widgets/filmstock_format_edit_tile.dart';
import 'package:film_log/pages/gear/widgets/gear_view_page.dart';
import 'package:film_log/pages/gear/widgets/shutterspeed_edit_tile.dart';
import 'package:film_log/pages/gear/widgets/text_edit_tile.dart';
import 'package:film_log/service/camera_repo.dart';
import 'package:film_log/widgets/shutter_list_widget.dart';
import 'package:flutter/material.dart';

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
            label: 'Name',
            value: item.name,
            edit: edit,
            onUpdate: onUpdate((value) => item.update(name: value)),
          ),
          TextEditTile(
            label: 'Manufacturer',
            value: item.manufacturer,
            edit: edit,
            onUpdate: onUpdate((value) => item.update(manufacturer: value)),
          ),
          TextEditTile(
            label: 'Product',
            value: item.product,
            edit: edit,
            onUpdate: onUpdate((value) => item.update(product: value)),
          ),
          ShutterSpeedEditTile(
            label: 'Min shutter speed',
            edit: edit,
            value: item.fastestShutterSpeed,
            max: item.slowestShutterSpeed,
            onUpdate: onUpdate((value) => item.update(fastestShutterSpeed: value)),
          ),
          ShutterSpeedEditTile(
            label: 'Max shutter speed',
            edit: edit,
            value: item.slowestShutterSpeed,
            min: item.fastestShutterSpeed,
            onUpdate: onUpdate((value) => item.update(slowestShutterSpeed: value)),
          ),
          FilmstockFormatEditTile(
            label: 'Film format',
            value: item.filmstockFormat,
            edit: edit,
            onUpdate: onUpdate((value) => item.update(filmstockFormat: value)),
          ),
        ],
      );
}
