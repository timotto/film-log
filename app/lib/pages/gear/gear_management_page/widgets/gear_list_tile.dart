import 'package:flutter/material.dart';

import '../../../../model/gear.dart';
import '../../../../service/gear_repo.dart';
import '../../gear_list_page/gear_list_page.dart';

class GearListTile<T extends Gear> extends StatelessWidget {
  const GearListTile({
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

  @override
  Widget build(BuildContext context) => StreamBuilder(
      stream: repo.itemsStream(),
      initialData: repo.items(),
      builder: (context, items) => ListTile(
            title: _title(),
            subtitle: _subtitle(items.data ?? []),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => GearListPage(
                label: label,
                labelEmpty: labelEmpty,
                repo: repo,
                itemPageBuilder: itemPageBuilder,
                itemCreator: itemCreator,
              ),
            )),
          ));

  Widget _title() => Text(label);

  Widget? _subtitle(List<T> items) => items.isNotEmpty
      ? Text(items.map((item) => item.collectionTitle()).join(', '))
      : null;
}
