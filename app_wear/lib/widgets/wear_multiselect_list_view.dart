import 'package:film_log_wear/widgets/accept_button.dart';
import 'package:film_log_wear/widgets/wear_list_tile.dart';
import 'package:film_log_wear/widgets/wear_list_view.dart';
import 'package:flutter/material.dart';

class WearMultiSelectListView<T> extends StatefulWidget {
  const WearMultiSelectListView({
    super.key,
    required this.selected,
    required this.values,
    required this.titleBuilder,
    required this.onAccept,
  });

  final List<T> selected;
  final List<T> values;
  final String Function(T) titleBuilder;
  final void Function(List<T>) onAccept;

  @override
  State<WearMultiSelectListView<T>> createState() =>
      _WearMultiSelectListViewState<T>();
}

class _WearMultiSelectListViewState<T>
    extends State<WearMultiSelectListView<T>> {
  List<T> values = [];

  @override
  void initState() {
    values = [...widget.selected];
    super.initState();
  }

  @override
  Widget build(BuildContext context) => WearListView(
        selectedIndex: _firstSelectedIndex(),
        children: [
          ..._children(context),
          _acceptButton(context),
        ],
      );

  List<Widget> _children(BuildContext context) => widget.values
      .map((value) => _listTile(context, value))
      .toList(growable: false);

  Widget _listTile(BuildContext context, T value) => WearListTile(
        title: widget.titleBuilder(value),
        selected: _isSelected(value),
        onTap: () => _toggleSelected(value),
      );

  Widget _acceptButton(BuildContext context) => AcceptButton(
        onPressed: () => widget.onAccept(values),
      );

  int? _firstSelectedIndex() {
    if (values.isEmpty) return null;
    final indices = values
        .map((item) => widget.values.indexOf(item))
        .where((index) => index != -1)
        .toList(growable: false)
      ..sort();
    if (indices.isEmpty) return null;
    return indices.first + 1;
  }

  bool _isSelected(T item) => values.contains(item);

  void _toggleSelected(T item) {
    setState(() {
      if (_isSelected(item)) {
        values.remove(item);
      } else {
        values.add(item);
      }
    });
  }
}
