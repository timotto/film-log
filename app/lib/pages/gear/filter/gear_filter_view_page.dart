import 'package:film_log/model/filter.dart';
import 'package:film_log/pages/gear/widgets/gear_view_page.dart';
import 'package:film_log/pages/gear/widgets/multiselect_edit_tile.dart';
import 'package:film_log/pages/gear/widgets/text_edit_tile.dart';
import 'package:film_log/service/filter_repo.dart';
import 'package:film_log/service/lens_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GearFilterViewPage extends StatelessWidget {
  const GearFilterViewPage({
    super.key,
    required this.item,
    required this.repo,
    required this.lensRepo,
    this.create,
  });

  final Filter item;
  final FilterRepo repo;
  final LensRepo lensRepo;
  final bool? create;

  @override
  Widget build(BuildContext context) => GearViewPage<Filter>(
        item: item,
        repo: repo,
        create: create,
        tilesBuilder: _tilesBuilder,
      );

  List<Widget> _tilesBuilder(BuildContext context, Filter item, bool edit,
          OnUpdateFn<Filter> onUpdate) =>
      [
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
          label: AppLocalizations.of(context).gearTitleTitleLenses,
          values: item.lenses,
          repo: lensRepo,
          edit: edit,
          onUpdate: onUpdate((value) => item.update(lenses: value)),
        ),
      ];
}
