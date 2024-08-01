import 'package:film_log_wear/model/aperture.dart';
import 'package:film_log_wear/model/photo.dart';
import 'package:film_log_wear/pages/film_list_page.dart';
import 'package:film_log_wear/service/wear_data.dart';
import 'package:flutter/material.dart';

import 'model/filter.dart';
import 'model/lens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _wearData = WearDataService();

  final photo = Photo(
    id: '1',
    frameNumber: 1,
    recorded: DateTime.timestamp(),
    shutterSpeed: 1 / 250,
    aperture: 8,
    lens: null,
    filters: [],
    location: null,
  );

  final List<Lens> lenses = [
    Lens(id: '1', label: '55mm', apertures: aperturesWhole(), cameras: []),
    Lens(id: '2', label: '90mm', apertures: aperturesWhole(), cameras: []),
  ];

  final List<Filter> filters = [
    Filter(id: '1', label: 'Red', lenses: []),
    Filter(id: '2', label: 'IR', lenses: []),
  ];

  @override
  void initState() {
    _wearData.setup().then((_) {});
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
      home: FilmListPage(),
    );
  }
}
