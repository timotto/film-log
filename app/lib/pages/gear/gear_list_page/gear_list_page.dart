import 'package:flutter/material.dart';

import '../../../model/gear.dart';
import '../../../service/gear_repo.dart';
import 'widgets/gear_list_item_tile.dart';

class GearListPage<T extends Gear> extends StatelessWidget {
  const GearListPage({
    super.key,
    required this.label,
    required this.labelEmpty,
    required this.repo,
    required this.itemPageBuilder,
    required this.itemCreator,
  });

  final String label;
  final String labelEmpty;
  final GearRepo<T> repo;
  final Widget Function(BuildContext, T, {bool? create}) itemPageBuilder;
  final T Function() itemCreator;

  Future<void> _createItem(BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => itemPageBuilder(
        context,
        itemCreator(),
        create: true,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(label),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _createItem(context),
          child: const Icon(Icons.add),
        ),
        body: StreamBuilder(
          stream: repo.itemsStream(),
          initialData: repo.items(),
          builder: (context, items) => _body(context, (items.data ?? [])),
        ),
      );

  Widget _body(BuildContext context, List<T> items) =>
      items.isNotEmpty ? _items(context, items) : _empty(context);

  Widget _items(BuildContext context, List<T> items) => ListView(
        children: items
            .map((item) => GearListItemTile(
                  item: item,
                  itemPageBuilder: itemPageBuilder,
                ))
            .toList(
              growable: false,
            ),
      );

  Widget _empty(BuildContext context) => Center(
        child: Text(labelEmpty),
      );
}
