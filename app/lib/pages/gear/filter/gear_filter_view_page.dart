import 'package:film_log/pages/gear/widgets/gear_view_page.dart';
import 'package:film_log/pages/gear/widgets/multiselect_edit_tile.dart';
import 'package:film_log/pages/gear/widgets/text_edit_tile.dart';
import 'package:film_log/service/filter_repo.dart';
import 'package:film_log/service/lens_repo.dart';
import 'package:flutter/material.dart';

import '../../../model/filter.dart';

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
          label: 'Lenses',
          values: item.lenses,
          repo: lensRepo,
          edit: edit,
          onUpdate: onUpdate((value) => item.update(lenses: value)),
        ),
      ];
}
