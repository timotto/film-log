import 'package:film_log_wear/model/film.dart';
import 'package:film_log_wear/pages/film_instance_page.dart';
import 'package:film_log_wear/widgets/wear_list_tile.dart';
import 'package:film_log_wear/widgets/wear_list_view.dart';
import 'package:flutter/material.dart';

import '../service/film_repo.dart';

class FilmListPage extends StatelessWidget {
  FilmListPage({super.key});

  final _repo = FilmRepo();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
          stream: _repo.stream(),
          initialData: _repo.value(),
          builder: (context, items) => _body(context, items.data ?? []),
        ),
      );

  Widget _body(BuildContext context, List<Film> items) =>
      items.isNotEmpty ? _list(context, items) : _empty(context);

  Widget _list(BuildContext context, List<Film> items) => WearListView(
        children: _children(context, items),
      );

  List<Widget> _children(BuildContext context, List<Film> items) => items
      .map((item) => WearListTile(
            title: item.label,
            onTap: () => _select(context, item),
          ))
      .toList(growable: false);

  Widget _empty(BuildContext context) => const Center(
        child: Text('There are no films'),
      );

  Future<void> _select(BuildContext context, Film item) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => FilmInstancePage(film: item),
    ));
  }
}
