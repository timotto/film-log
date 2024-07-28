import 'package:flutter/material.dart';

import '../../../../model/gear.dart';

class GearListItemTile<T extends Gear> extends StatelessWidget {
  const GearListItemTile({
    super.key,
    required this.item,
    required this.itemPageBuilder,
  });

  final T item;
  final Widget Function(BuildContext, T) itemPageBuilder;

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(item.listItemTitle()),
        subtitle: Text(item.listItemSubtitle()),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => itemPageBuilder(context, item),
        )),
      );
}
