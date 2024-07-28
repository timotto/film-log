import 'package:film_log/model/gear.dart';
import 'package:film_log/service/gear_repo.dart';
import 'package:flutter/material.dart';

class GearMultiselectPage<T extends Gear> extends StatefulWidget {
  const GearMultiselectPage({
    super.key,
    required this.label,
    required this.values,
    required this.repo,
    this.filter,
  });

  final String label;
  final List<T> values;
  final GearRepo<T> repo;
  final bool Function(T)? filter;

  @override
  State<StatefulWidget> createState() => _GearMultiselectPageState<T>();
}

class _GearMultiselectPageState<T extends Gear>
    extends State<GearMultiselectPage<T>> {
  final List<T> _values = [];

  @override
  void initState() {
    _values.addAll(widget.values);
    super.initState();
  }

  bool _isSelected(T camera) =>
      _values.where((item) => item.itemId() == camera.itemId()).isNotEmpty;

  void _select(T camera, bool select) => setState(() {
        if (select) {
          _values.add(camera);
        } else {
          _values.removeWhere((item) => item.itemId() == camera.itemId());
        }
      });

  void _save(BuildContext context) {
    Navigator.of(context).pop(_values);
  }

  List<T> _filter(List<T> items) => widget.filter == null
      ? items
      : items.where(widget.filter!).toList(growable: false);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.label),
          actions: [
            IconButton(
              onPressed: () => _save(context),
              icon: const Icon(Icons.check),
            ),
          ],
        ),
        body: StreamBuilder(
          stream: widget.repo.itemsStream(),
          initialData: widget.repo.items(),
          builder: (context, items) =>
              _body(context, _filter(items.data ?? [])),
        ),
      );

  Widget _body(BuildContext context, List<T> items) =>
      items.isNotEmpty ? _listView(context, items) : _emptyList(context);

  Widget _listView(BuildContext context, List<T> items) => ListView(
        children: items
            .map((item) => CheckboxListTile(
                  title: Text(item.listItemTitle()),
                  subtitle: Text(item.listItemSubtitle()),
                  value: _isSelected(item),
                  onChanged: (v) => _select(item, v ?? false),
                ))
            .toList(growable: false),
      );

  Widget _emptyList(BuildContext context) => Center(
        child: Text('There are no ${widget.label}'),
      );
}
