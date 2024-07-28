import 'package:flutter/material.dart';

import '../../../model/filmstock_format.dart';
import 'preset_edit_tile.dart';

class FilmstockFormatEditTile extends StatelessWidget {
  const FilmstockFormatEditTile({
    super.key,
    required this.label,
    required this.value,
    required this.edit,
    required this.onUpdate,
  });

  final String label;
  final FilmStockFormat value;
  final bool edit;
  final void Function(FilmStockFormat) onUpdate;

  @override
  Widget build(BuildContext context) => PresetEditTile(
        label: label,
        values: const <FilmStockFormat, String>{
          FilmStockFormat.type120: '120',
          FilmStockFormat.type127: '127',
          FilmStockFormat.type135: '135',
          FilmStockFormat.typeOther: 'Other',
        },
        value: value,
        edit: edit,
        onUpdate: onUpdate,
      );
}
