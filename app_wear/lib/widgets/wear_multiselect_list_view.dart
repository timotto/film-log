import 'package:film_log_wear/widgets/wear_list_tile.dart';
import 'package:film_log_wear/widgets/wear_list_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WearMultiSelectListView<T> extends StatefulWidget {
  const WearMultiSelectListView({
    super.key,
    required this.selected,
    required this.values,
    required this.titleBuilder,
  });

  final List<T> selected;
  final List<T> values;
  final String Function(T) titleBuilder;

  @override
  State<WearMultiSelectListView<T>> createState() =>
      _WearMultiSelectListViewState<T>();
}

class _WearMultiSelectListViewState<T>
    extends State<WearMultiSelectListView<T>> {
  @override
  Widget build(BuildContext context) => WearListView(
        selectedIndex: _firstSelectedIndex(),
        children: [
          _acceptButton(context),
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

  Widget _acceptButton(BuildContext context) => IconButton(
        onPressed: () => Navigator.of(context).pop(widget.selected),
        icon: const Icon(Icons.check),
      );

  int? _firstSelectedIndex() {
    if (widget.selected.isEmpty) return null;
    final indices = widget.selected
        .map((item) => widget.values.indexOf(item))
        .where((index) => index != -1)
        .toList(growable: false)
      ..sort();
    if (indices.isEmpty) return null;
    return indices.first + 1;
  }

  bool _isSelected(T item) => widget.selected.contains(item);

  void _toggleSelected(T item) {
    setState(() {
      if (_isSelected(item)) {
        widget.selected.remove(item);
      } else {
        widget.selected.add(item);
      }
    });
  }
}
