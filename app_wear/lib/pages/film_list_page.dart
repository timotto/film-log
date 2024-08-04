import 'package:film_log_wear/model/film.dart';
import 'package:film_log_wear/pages/film_instance_page.dart';
import 'package:film_log_wear/widgets/open_on_phone_button.dart';
import 'package:film_log_wear/widgets/swipe_dismiss.dart';
import 'package:film_log_wear/widgets/wear_list_tile.dart';
import 'package:film_log_wear/widgets/wear_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../service/film_repo.dart';
import 'add_film_page.dart';

class FilmListPage extends StatelessWidget {
  FilmListPage({super.key});

  final _listKey = GlobalKey();
  final _repo = FilmRepo();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SwipeDismiss(
          onDismissed: () => SystemNavigator.pop(),
          child: StreamBuilder(
            stream: _repo.stream(),
            initialData: _repo.value(),
            builder: (context, items) => _body(context, items.data ?? []),
          ),
        ),
      );

  Widget _body(BuildContext context, List<Film> items) =>
      items.isNotEmpty ? _list(context, items) : _empty(context);

  Widget _list(BuildContext context, List<Film> items) => WearListView(
        key: _listKey,
        selectedIndex: items.length,
        children: [
          ..._children(context, items),
          _addButton(context),
        ],
      );

  List<Widget> _children(BuildContext context, List<Film> items) => items
      .map((item) => WearListTile(
            title: item.label,
            subtitle: item.listItemSubtitle(),
            onTap: () => _select(context, item),
          ))
      .toList(growable: false);

  Widget _empty(BuildContext context) => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('No films available'),
            OpenOnPhoneButton(),
          ],
        ),
      );

  Widget _addButton(BuildContext context) => IconButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const AddFilmPage(),
          ),
        ),
        icon: const Icon(Icons.add),
      );

  Future<void> _select(BuildContext context, Film item) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => FilmInstancePage(filmId: item.id),
    ));
  }
}
