import 'package:film_log/model/film_stock.dart';
import 'package:film_log/model/filmstock_format.dart';
import 'package:film_log/pages/gear/widgets/gear_select_page.dart';
import 'package:film_log/service/filmstock_repo.dart';
import 'package:flutter/material.dart';

class FilmstockEditTile extends StatelessWidget {
  const FilmstockEditTile({
    super.key,
    required this.label,
    required this.value,
    required this.format,
    required this.repo,
    required this.edit,
    required this.onUpdate,
  });

  final String label;
  final FilmStock? value;
  final FilmStockFormat? format;
  final FilmstockRepo repo;
  final bool edit;
  final void Function(FilmStock?) onUpdate;

  Future<void> _onTap(BuildContext context) async {
    final result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => GearSelectPage<FilmStock>(
        label: label,
        value: value,
        repo: repo,
        filter: format == null ? null : (item) => item.format == format,
      ),
    ));
    if (result != null) {
      onUpdate(result);
    }
  }

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(value?.listItemTitle() ?? ''),
        subtitle: Text(label),
        trailing: edit ? const Icon(Icons.edit) : null,
        onTap: edit ? () => _onTap(context) : null,
      );
}
