import 'package:film_log/model/fstop.dart';
import 'package:film_log/pages/gear/widgets/aperture_edit_tile.dart';
import 'package:film_log/pages/gear/widgets/double_edit_tile.dart';
import 'package:film_log/pages/gear/widgets/gear_view_page.dart';
import 'package:film_log/pages/gear/widgets/multiselect_edit_tile.dart';
import 'package:film_log/pages/gear/widgets/preset_edit_tile.dart';
import 'package:film_log/pages/gear/widgets/text_edit_tile.dart';
import 'package:film_log/service/camera_repo.dart';
import 'package:film_log/service/lens_repo.dart';
import 'package:flutter/material.dart';

import '../../../model/lens.dart';

class GearLensViewPage extends StatelessWidget {
  const GearLensViewPage({
    super.key,
    required this.item,
    required this.repo,
    required this.cameraRepo,
    this.create,
  });

  final Lens item;
  final LensRepo repo;
  final CameraRepo cameraRepo;
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
          MultiselectEditTile(
            label: 'Cameras',
            values: item.cameras,
            repo: cameraRepo,
            edit: edit,
            onUpdate: onUpdate((value) => item.update(cameras: value)),
          ),
          PresetEditTile(
            label: 'Type',
            values: const <LensType, String>{
              LensType.prime: 'Prime',
              LensType.zoom: 'Zoom',
            },
            value: item.type,
            edit: edit,
            onUpdate: onUpdate((value) => item.update(type: value)),
          ),
          ..._focalLengthTiles(
            context,
            item: item,
            edit: edit,
            onUpdate: onUpdate,
          ),
          PresetEditTile(
            label: 'F-Stop increments',
            values: const <FStopIncrements, String>{
              FStopIncrements.full: 'Full',
              FStopIncrements.half: '1/2',
              FStopIncrements.third: '1/3',
            },
            value: item.fStopIncrements,
            edit: edit,
            onUpdate: onUpdate((value) => item.update(fStopIncrements: value)),
          ),
          ..._apertureTiles(
            context,
            item: item,
            edit: edit,
            onUpdate: onUpdate,
          ),
        ],
      );

  List<Widget> _focalLengthTiles(
    BuildContext context, {
    required Lens item,
    required bool edit,
    required OnUpdateFn<Lens> onUpdate,
  }) =>
      item.type == LensType.prime
          ? [
              DoubleEditTile(
                label: 'Focal length',
                value: item.focalLengthMin,
                edit: edit,
                valueToString: (v) => v.toStringAsFixed(0),
                stringToValue: double.tryParse,
                onUpdate: onUpdate((value) => item.update(
                      focalLengthMin: value,
                      focalLengthMax: value,
                    )),
              ),
            ]
          : [
              DoubleEditTile(
                label: 'Focal length min',
                value: item.focalLengthMin,
                edit: edit,
                valueToString: (v) => v.toStringAsFixed(0),
                stringToValue: double.tryParse,
                onUpdate: onUpdate((value) => item.update(
                      focalLengthMin: value,
                    )),
              ),
              DoubleEditTile(
                label: 'Focal length max',
                value: item.focalLengthMax,
                edit: edit,
                valueToString: (v) => v.toStringAsFixed(0),
                stringToValue: double.tryParse,
                onUpdate: onUpdate((value) => item.update(
                      focalLengthMax: value,
                    )),
              ),
            ];

  List<Widget> _apertureTiles(
    BuildContext context, {
    required Lens item,
    required bool edit,
    required OnUpdateFn<Lens> onUpdate,
  }) =>
      [
        ApertureEditTile(
          label: 'Aperture min',
          edit: edit,
          value: item.apertureMin,
          max: item.apertureMax,
          increments: item.fStopIncrements,
          onUpdate: onUpdate((value) => item.update(apertureMin: value)),
        ),
        ApertureEditTile(
          label: 'Aperture max',
          edit: edit,
          value: item.apertureMax,
          min: item.apertureMin,
          increments: item.fStopIncrements,
          onUpdate: onUpdate((value) => item.update(apertureMax: value)),
        ),
      ];
}
