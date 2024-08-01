import 'package:film_log_wear/widgets/wear_list_tile.dart';
import 'package:film_log_wear/widgets/wear_list_view.dart';
import 'package:flutter/material.dart';

class WearSelectListView<T> extends StatelessWidget {
  const WearSelectListView({
    super.key,
    this.value,
    required this.values,
    required this.titleBuilder,
  });

  final T? value;
  final List<T> values;
  final String Function(T) titleBuilder;

  @override
  Widget build(BuildContext context) => WearListView(
    selectedIndex: _selectedIndex(),
    children: _children(context),
  );

  List<Widget> _children(BuildContext context) => values
      .map((value) => _listTile(context, value))
      .toList(growable: false);

  Widget _listTile(BuildContext context, T value) =>
      WearListTile(
        title: titleBuilder(value),
        selected: value == this.value,
        onTap: () => Navigator.pop(context, value),
      );

  int? _selectedIndex() {
    if (value == null) return null;
    final index = values.indexOf(value!);
    if (index == -1) return null;
    return index;
  }
}
