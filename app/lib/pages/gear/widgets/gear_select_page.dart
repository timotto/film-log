import 'package:film_log/model/gear.dart';
import 'package:film_log/service/gear_repo.dart';
import 'package:flutter/material.dart';

class GearSelectPage<T extends Gear> extends StatelessWidget {
  const GearSelectPage({
    super.key,
    required this.label,
    required this.value,
    required this.repo,
    this.filter,
  });

  final String label;
  final T? value;
  final GearRepo<T> repo;
  final bool Function(T)? filter;

  bool _isSelected(T item) => value?.itemId() == item.itemId();

  void _select(BuildContext context, T item) {
    Navigator.of(context).pop(item);
  }

  List<T> _filter(List<T> items) =>
      filter == null ? items : items.where(filter!).toList(growable: false);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(label),
        ),
        body: StreamBuilder(
          stream: repo.itemsStream(),
          initialData: repo.items(),
          builder: (context, items) =>
              _body(context, _filter(items.data ?? [])),
        ),
      );

  Widget _body(BuildContext context, List<T> items) =>
      items.isNotEmpty ? _listView(context, items) : _emptyList(context);

  Widget _listView(BuildContext context, List<T> items) => ListView(
        children: items
            .map((item) => ListTile(
                  title: Text(item.listItemTitle()),
                  subtitle: Text(item.listItemSubtitle()),
                  selected: _isSelected(item),
                  trailing: _isSelected(item) ? const Icon(Icons.check) : null,
                  onTap: () => _select(context, item),
                ))
            .toList(growable: false),
      );

  Widget _emptyList(BuildContext context) => Center(
        child: Text('There are no $label'),
      );
}
