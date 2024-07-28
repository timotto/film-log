import 'package:film_log/model/film_stock.dart';
import 'package:film_log/model/filmstock_format.dart';
import 'package:film_log/pages/gear/widgets/double_edit_tile.dart';
import 'package:film_log/pages/gear/widgets/filmstock_format_edit_tile.dart';
import 'package:film_log/pages/gear/widgets/gear_view_page.dart';
import 'package:film_log/pages/gear/widgets/preset_edit_tile.dart';
import 'package:film_log/pages/gear/widgets/text_edit_tile.dart';
import 'package:film_log/service/filmstock_repo.dart';
import 'package:flutter/material.dart';

class GearFilmstockViewPage extends StatelessWidget {
  const GearFilmstockViewPage({
    super.key,
    required this.item,
    required this.repo,
    this.create,
  });

  final FilmStock item;
  final FilmstockRepo repo;
  final bool? create;

  @override
  Widget build(BuildContext context) => GearViewPage(
        item: item,
        repo: repo,
        create: create,
        tilesBuilder: _tilesBuilder,
      );

  List<Widget> _tilesBuilder(BuildContext context, FilmStock item, bool edit,
          OnUpdateFn<FilmStock> onUpdate) =>
      [
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
        DoubleEditTile(
          label: 'ISO',
          value: item.iso,
          edit: edit,
          valueToString: (v) => v.toStringAsFixed(0),
          stringToValue: double.tryParse,
          onUpdate: onUpdate((value) => item.update(iso: value)),
        ),
        FilmstockFormatEditTile(
          label: 'Format',
          value: item.format,
          edit: edit,
          onUpdate: onUpdate((value) => item.update(format: value)),
        ),
        PresetEditTile(
          label: 'Type',
          values: const <FilmStockType, String>{
            FilmStockType.color: 'Color',
            FilmStockType.blackAndWhitePanchromatic: 'B&W Panchromatic',
            FilmStockType.blackAndWhiteOrthochromatic: 'B&W Orthochromatic',
            FilmStockType.blackAndWhiteInfrared: 'B&W Infrared',
          },
          value: item.type,
          edit: edit,
          onUpdate: onUpdate((value) => item.update(type: value)),
        ),
      ];
}
