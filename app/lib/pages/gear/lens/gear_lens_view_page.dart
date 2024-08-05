import 'package:film_log/model/fstop.dart';
import 'package:film_log/model/lens.dart';
import 'package:film_log/pages/gear/widgets/aperture_edit_tile.dart';
import 'package:film_log/pages/gear/widgets/double_edit_tile.dart';
import 'package:film_log/pages/gear/widgets/gear_view_page.dart';
import 'package:film_log/pages/gear/widgets/multiselect_edit_tile.dart';
import 'package:film_log/pages/gear/widgets/preset_edit_tile.dart';
import 'package:film_log/pages/gear/widgets/text_edit_tile.dart';
import 'package:film_log/service/camera_repo.dart';
import 'package:film_log/service/lens_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          MultiselectEditTile(
            label: AppLocalizations.of(context).gearTitleTitleCameras,
            values: item.cameras,
            repo: cameraRepo,
            edit: edit,
            onUpdate: onUpdate((value) => item.update(cameras: value)),
          ),
          PresetEditTile(
            label: AppLocalizations.of(context).gearTitleTitleLensType,
            values: <LensType, String>{
              LensType.prime: AppLocalizations.of(context).labelLensTypePrime,
              LensType.zoom: AppLocalizations.of(context).labelLensTypeZoom,
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
            label: AppLocalizations.of(context).gearTitleTitleFStopIncrements,
            values: <FStopIncrements, String>{
              FStopIncrements.full:
                  AppLocalizations.of(context).labelFStopIncrementsFull,
              FStopIncrements.half:
                  AppLocalizations.of(context).labelFStopIncrementsHalf,
              FStopIncrements.third:
                  AppLocalizations.of(context).labelFStopIncrementsThird,
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
                label: AppLocalizations.of(context).gearTitleTitleFocalLength,
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
                label:
                    AppLocalizations.of(context).gearTitleTitleFocalLengthMin,
                value: item.focalLengthMin,
                edit: edit,
                valueToString: (v) => v.toStringAsFixed(0),
                stringToValue: double.tryParse,
                onUpdate: onUpdate((value) => item.update(
                      focalLengthMin: value,
                    )),
              ),
              DoubleEditTile(
                label:
                    AppLocalizations.of(context).gearTitleTitleFocalLengthMax,
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
          label: AppLocalizations.of(context).gearTitleTitleApertureMin,
          edit: edit,
          value: item.apertureMin,
          max: item.apertureMax,
          increments: item.fStopIncrements,
          onUpdate: onUpdate((value) => item.update(apertureMin: value)),
        ),
        ApertureEditTile(
          label: AppLocalizations.of(context).gearTitleTitleApertureMax,
          edit: edit,
          value: item.apertureMax,
          min: item.apertureMin,
          increments: item.fStopIncrements,
          onUpdate: onUpdate((value) => item.update(apertureMax: value)),
        ),
      ];
}
