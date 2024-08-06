import 'package:film_log/pages/film_list_page/film_list_page.dart';
import 'package:film_log/service/repos.dart';
import 'package:film_log/service/wear_data.dart';
import 'package:film_log/widgets/wear_companion_checker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logging/logging.dart';

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

  late Future _initialized;

  @override
  void initState() {
    _setupLogging();
    _wearData = WearDataService(repos: _repos);
    _initialized = _init();
    super.initState();
  }

  Future<void> _init() async {
    await _repos.load();
    await _wearData.setup();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: WearCompanionChecker(
        wearDataService: _wearData,
        child: FutureBuilder(
          future: _initialized,
          builder: (_, __) => FilmListPage(
            repo: _repos.filmRepo,
            repos: _repos,
          ),
        ),
      ),
    );
  }

  void _setupLogging() {
    Logger.root.level = kReleaseMode ? Level.INFO : Level.ALL;
    Logger.root.onRecord.listen((record) {
      final List<String> parts = [
        record.level.name,
        record.time.toString(),
        record.message,
        if (record.error != null) record.error!.toString(),
      ];
      print(parts.join(': '));
    });
  }
}
