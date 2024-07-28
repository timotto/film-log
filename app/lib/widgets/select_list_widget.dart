import 'package:flutter/material.dart';

class SelectListWidget<T> extends StatelessWidget {
  const SelectListWidget({
    super.key,
    required this.items,
    this.value,
    required this.onTap,
  });

  final List<MapEntry<T, String>> items;
  final T? value;
  final void Function(T) onTap;

  @override
  Widget build(BuildContext context) => ListView(
        children: this
            .items
            .map((item) => ListTile(
                  title: Text(item.value),
                  selected: item.key == value,
                  trailing: item.key == value ? const Icon(Icons.check) : null,
                  onTap: () => onTap(item.key),
                ))
            .toList(growable: false),
      );
}
