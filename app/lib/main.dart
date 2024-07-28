import 'package:film_log/pages/film_list_page/film_list_page.dart';
import 'package:film_log/service/repos.dart';
import 'package:flutter/material.dart';

import 'pages/gear/gear_management_page/gear_management_page.dart';

void main() {
  runApp(FilmLog());
}

class FilmLog extends StatelessWidget {
  FilmLog({super.key});

  final _repos = Repos();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Film Log',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: _repos.load(),
        builder: (_,__) => FilmListPage(
          repo: _repos.filmRepo,
          repos: _repos,
        ),
      ),
    );
  }
}
