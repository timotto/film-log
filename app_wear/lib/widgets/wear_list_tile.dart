import 'package:flutter/material.dart';

class WearListTile extends StatelessWidget {
  const WearListTile({
    super.key,
    this.title,
    this.subtitle,
    this.selected = false,
    this.onTap,
  });

  final String? title;
  final String? subtitle;
  final bool selected;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) => ListTile(
        title: _title(context),
        subtitle: _subtitle(context),
        selected: selected,
        selectedColor: Colors.red,
        // selectedColor: Theme.of(context).colorScheme.onPrimary,
        // selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
        onTap: onTap,
      );

  Widget? _title(BuildContext context) =>
      title == null ? null : _centerText(context, title!);

  Widget? _subtitle(BuildContext context) =>
      subtitle == null ? null : _centerText(context, subtitle!);

  Widget _centerText(BuildContext context, String text) => Text(
        text,
        textAlign: TextAlign.center,
      );
}
