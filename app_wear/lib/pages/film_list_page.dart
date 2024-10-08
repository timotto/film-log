import 'package:film_log_wear/model/film.dart';
import 'package:film_log_wear/pages/about_app/about_app_page.dart';
import 'package:film_log_wear/pages/film_instance_page.dart';
import 'package:film_log_wear/service/wear_data.dart';
import 'package:film_log_wear/widgets/add_button.dart';
import 'package:film_log_wear/widgets/swipe_dismiss.dart';
import 'package:film_log_wear/widgets/wear_list_tile.dart';
import 'package:film_log_wear/widgets/wear_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../service/film_repo.dart';
import 'add_film_page.dart';

class FilmListPage extends StatelessWidget {
  FilmListPage({super.key});

  final _listKey = GlobalKey();
  final _data = WearDataService();
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
        itemExtend: 48,
        children: [
          _aboutAppButton(context),
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

  Widget _empty(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context).filmListNoFilms),
            _addButton(context),
            _aboutAppButton(context),
          ],
        ),
      );

  Widget _aboutAppButton(BuildContext context) => ElevatedButton.icon(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const AboutAppPage(),
          ),
        ),
        icon: const Icon(Icons.info),
        label: Text(AppLocalizations.of(context).buttonAboutApp),
      );

  Widget _addButton(BuildContext context) => AddButton(
        onPressed: () => _addFilmInstance(context),
      );

  Future<void> _select(BuildContext context, Film item) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => FilmInstancePage(filmId: item.id),
    ));
  }

  Future<void> _addFilmInstance(BuildContext context) async {
    final result = await Navigator.of(context).push<Film>(MaterialPageRoute(
      builder: (_) => AddFilmPage(
        name: AppLocalizations.of(context)
            .addFilmNameTemplate(_repo.value().length + 1),
      ),
    ));
    if (result == null || !context.mounted) return;

    await _data.sendFilm(result);
  }
}
