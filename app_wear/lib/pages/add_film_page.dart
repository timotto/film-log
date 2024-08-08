import 'package:film_log_wear/model/camera.dart';
import 'package:film_log_wear/model/film.dart';
import 'package:film_log_wear/model/filmstock.dart';
import 'package:film_log_wear/model/iso.dart';
import 'package:film_log_wear/service/camera_repo.dart';
import 'package:film_log_wear/service/filmstock_repo.dart';
import 'package:film_log_wear/widgets/swipe_dismiss.dart';
import 'package:film_log_wear/widgets/wear_list_tile.dart';
import 'package:film_log_wear/widgets/wear_list_view.dart';
import 'package:film_log_wear/widgets/wear_select_list_view.dart';
import 'package:film_log_wear/widgets/wear_text_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:uuid/v4.dart';

class AddFilmPage extends StatefulWidget {
  const AddFilmPage({super.key, required this.name});

  final String name;

  @override
  State<AddFilmPage> createState() => _AddFilmPageState();
}

class _AddFilmPageState extends State<AddFilmPage> {
  final _listKey = GlobalKey();

  final cameraRepo = CameraRepo();
  final filmStockRepo = FilmStockRepo();

  late String name;
  Camera? camera;
  FilmStock? filmStock;
  double? iso;
  int? framesPerFilm;

  @override
  void initState() {
    name = widget.name;
    super.initState();
  }

  void _save(BuildContext context) {
    final result = Film(
      id: const UuidV4().generate(),
      label: name,
      inserted: DateTime.now(),
      maxPhotoCount: framesPerFilm ?? 10,
      camera: camera,
      actualIso: iso,
      filmStockId: filmStock?.id,
      photos: [],
    );

    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SwipeDismiss(
          child: WearListView(
            key: _listKey,
            children: [
              WearListTile(
                title: AppLocalizations.of(context).addFilmTitleTitleName,
                subtitle: name,
                onTap: () => _editName(context),
              ),
              WearListTile(
                title: AppLocalizations.of(context).addFilmTitleTitleCamera,
                subtitle: camera?.label,
                onTap: () => _editCamera(context),
              ),
              WearListTile(
                title: AppLocalizations.of(context).addFilmTitleTitleFilmStock,
                subtitle: filmStock?.label,
                onTap: () => _editFilmStock(context),
              ),
              WearListTile(
                title: AppLocalizations.of(context).addFilmTitleTitleISO,
                subtitle: iso?.toStringAsFixed(0),
                onTap: () => _editIso(context),
              ),
              WearListTile(
                title:
                    AppLocalizations.of(context).addFilmTitleTitleFramesPerFilm,
                subtitle: framesPerFilm?.toStringAsFixed(0),
                onTap: () => _editFramesPerFilm(context),
              ),
              _acceptButton(context),
            ],
          ),
        ),
      );

  Widget _acceptButton(BuildContext context) => IconButton(
        onPressed: () => _save(context),
        icon: const Icon(Icons.check),
      );

  Future<void> _editName(BuildContext context) async {
    final result = await Navigator.of(context).push<String>(MaterialPageRoute(
      builder: (_) => WearTextEdit(
        label: AppLocalizations.of(context).addFilmTitleTitleName,
        value: name,
      ),
    ));

    if (result == null || !mounted || !context.mounted) return;
    setState(() {
      name = result;
    });
  }

  Future<void> _editCamera(BuildContext context) async {
    final result = await Navigator.of(context).push<Camera>(MaterialPageRoute(
      builder: (_) => _SelectCameraPage(
        value: camera,
        values: cameraRepo.value(),
      ),
    ));

    if (result == null || !mounted || !context.mounted) return;
    setState(() {
      camera = result;
      if (filmStock != null &&
          filmStock!.cameras.where((c) => c.id == result.id).isEmpty) {
        filmStock = null;
      }
      framesPerFilm = camera?.defaultFramesPerFilm ?? framesPerFilm;
    });
  }

  Future<void> _editFilmStock(BuildContext context) async {
    final values = filmStockRepo
        .value()
        .where((item) => _filmStockMatchesCamera(item, camera))
        .toList();

    final value = filmStock == null
        ? null
        : values.where((item) => item.id == filmStock!.id).firstOrNull;

    final result =
        await Navigator.of(context).push<FilmStock>(MaterialPageRoute(
      builder: (_) => _SelectFilmStockPage(
        value: value,
        values: values,
      ),
    ));

    if (result == null || !mounted || !context.mounted) return;
    setState(() {
      filmStock = result;
      iso = filmStock?.iso;
    });
  }

  Future<void> _editIso(BuildContext context) async {
    final result = await Navigator.of(context).push<double>(MaterialPageRoute(
      builder: (_) => _SelectISOPage(
        value: iso,
        values: isoValues(),
      ),
    ));

    if (result == null || !mounted || !context.mounted) return;
    setState(() {
      iso = result;
    });
  }

  Future<void> _editFramesPerFilm(BuildContext context) async {
    final result = await Navigator.of(context).push<int>(MaterialPageRoute(
      builder: (_) => _SelectFramesPerFilmPage(
        value: framesPerFilm,
        values: _framesPerFilmValues(),
      ),
    ));

    if (result == null || !mounted || !context.mounted) return;
    setState(() {
      framesPerFilm = result;
    });
  }
}

class _SelectCameraPage extends StatelessWidget {
  const _SelectCameraPage({
    required this.value,
    required this.values,
  });

  final Camera? value;
  final List<Camera> values;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SwipeDismiss(
          child: WearSelectListView(
            value: value,
            values: values,
            titleBuilder: (item) => item.label,
          ),
        ),
      );
}

class _SelectFilmStockPage extends StatelessWidget {
  const _SelectFilmStockPage({
    required this.value,
    required this.values,
  });

  final FilmStock? value;
  final List<FilmStock> values;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SwipeDismiss(
          child: WearSelectListView(
            value: value,
            values: values,
            titleBuilder: (item) => item.label,
          ),
        ),
      );
}

class _SelectISOPage extends StatelessWidget {
  const _SelectISOPage({
    required this.value,
    required this.values,
  });

  final double? value;
  final List<double> values;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SwipeDismiss(
          child: WearSelectListView(
            value: value,
            values: values,
            titleBuilder: (item) => item.toStringAsFixed(0),
          ),
        ),
      );
}

class _SelectFramesPerFilmPage extends StatelessWidget {
  const _SelectFramesPerFilmPage({
    required this.value,
    required this.values,
  });

  final int? value;
  final List<int> values;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SwipeDismiss(
          child: WearSelectListView(
            value: value,
            values: values,
            titleBuilder: (item) => item.toStringAsFixed(0),
          ),
        ),
      );
}

bool _filmStockMatchesCamera(FilmStock item, Camera? camera) => camera == null
    ? true
    : item.cameras.where((c) => c.id == camera.id).isNotEmpty;

List<int> _framesPerFilmValues() => [
      ...List.generate(36, (index) => index + 1),
      99,
    ];
