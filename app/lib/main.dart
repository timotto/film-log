import 'package:film_log/pages/film_list_page/film_list_page.dart';
import 'package:film_log/service/repos.dart';
import 'package:film_log/service/wear_data.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FilmLog());
}

class FilmLog extends StatefulWidget {
  const FilmLog({super.key});

  @override
  State<FilmLog> createState() => _FilmLogState();
}

class _FilmLogState extends State<FilmLog> {
  late final WearDataService _wearData;

  final _repos = Repos();

  @override
  void initState() {
    _wearData = WearDataService(repos: _repos);
    super.initState();
  }

  Future<void> _init() async {
    await _repos.load();
    await _wearData.setup();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Film Log',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: _init(),
        builder: (_,__) => FilmListPage(
          repo: _repos.filmRepo,
          repos: _repos,
        ),
      ),
    );
  }
}
