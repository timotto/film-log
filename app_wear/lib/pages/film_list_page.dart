import 'package:film_log_wear/model/film.dart';
import 'package:film_log_wear/pages/film_instance_page.dart';
import 'package:film_log_wear/service/wear_data.dart';
import 'package:film_log_wear/widgets/swipe_dismiss.dart';
import 'package:film_log_wear/widgets/wear_list_tile.dart';
import 'package:film_log_wear/widgets/wear_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../service/film_repo.dart';

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
        children: _children(context, items),
      );

  List<Widget> _children(BuildContext context, List<Film> items) => items
      .map((item) => WearListTile(
            title: item.label,
            onTap: () => _select(context, item),
          ))
      .toList(growable: false);

  Widget _empty(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('There are no films'),
            ElevatedButton.icon(
              onPressed: () => _openOnPhone(context),
              icon: const Icon(Icons.open_in_new),
              label: const Text('Open on Phone'),
            ),
          ],
        ),
      );

  Future<void> _select(BuildContext context, Film item) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => FilmInstancePage(film: item),
    ));
  }

  Future<void> _openOnPhone(BuildContext context) async {
    final data = WearDataService();
    data.fakeData();
  }
}
