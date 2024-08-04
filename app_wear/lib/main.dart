import 'package:film_log_wear/pages/film_list_page.dart';
import 'package:film_log_wear/pages/startup_page.dart';
import 'package:film_log_wear/service/wear_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wear_os_location/flutter_wear_os_location.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _location = FlutterWearOsLocation();
  final _wearData = WearDataService();

  @override
  void initState() {
    _wearData.setup().then((_) {});
    _location.ensurePermission().then((_) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Film Log',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.compact,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: StreamBuilder(
        stream: _wearData.initializedStream(),
        initialData: _wearData.initialized(),
        builder: (context, initialized) =>
            (initialized.data ?? false) ? FilmListPage() : const StartupPage(),
      ),
    );
  }
}
