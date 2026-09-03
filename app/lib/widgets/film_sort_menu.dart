import 'package:film_log/model/sort.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilmSortMenu extends StatelessWidget {
  FilmSortMenu({
    super.key,
    required this.order,
    required this.direction,
    required this.onUpdate,
  });

  final FilmSortOrder order;
  final SortOrderDirection direction;
  final void Function(FilmSortOrder, SortOrderDirection) onUpdate;

  final _controller = MenuController();

  void _toggleMenu() {
    if (_controller.isOpen) {
      _controller.close();
    } else {
      _controller.open();
    }
  }

  void _setSortOrder(FilmSortOrder order) {
    if (order == this.order) {
      _setSortDirection(direction == SortOrderDirection.ascending ? SortOrderDirection.descending : SortOrderDirection.ascending);
      return;
    }
    onUpdate(order, direction);
  }

  void _setSortDirection(SortOrderDirection direction) =>
      onUpdate(order, direction);

  List<Widget> _menuItems(BuildContext context) => [
        MapEntry(
          FilmSortOrder.label,
          AppLocalizations.of(context).menuItemSortFilmByLabel,
        ),
        MapEntry(
          FilmSortOrder.inserted,
          AppLocalizations.of(context).menuItemSortFilmByInserted,
        ),
        MapEntry(
          FilmSortOrder.lastPhoto,
          AppLocalizations.of(context).menuItemSortFilmByLastPhoto,
        ),
      ]
          .map((it) => MenuItemButton(
                onPressed: () => _setSortOrder(it.key),
                trailingIcon: _itemIcon(it.key),
                child: Text(it.value),
              ))
          .toList();

  Widget? _itemIcon(FilmSortOrder value) {
    if (order != value) return null;
    return Icon(direction == SortOrderDirection.ascending
        ? Icons.arrow_upward
        : Icons.arrow_downward);
  }

  @override
  Widget build(BuildContext context) => MenuAnchor(
        controller: _controller,
        menuChildren: _menuItems(context),
        child: IconButton(
          onPressed: _toggleMenu,
          icon: const Icon(Icons.sort),
        ),
      );
}
