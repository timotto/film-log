import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:film_log/model/film_instance.dart';
import 'package:film_log/model/film_stock.dart';
import 'package:film_log/model/filter.dart';
import 'package:film_log/model/lens.dart';
import 'package:film_log/service/repos.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../model/camera.dart';

class ImportService {
  const ImportService({required this.repos});

  final Repos repos;

  Future<void> importArchive(ImportArchive archive) async {
    await repos.thumbnailRepo.deleteAll();
    await repos.cameraRepo.replaceItems(archive.cameras);
    await repos.lensRepo.replaceItems(archive.lenses);
    await repos.filterRepo.replaceItems(archive.filters);
    await repos.filmstockRepo.replaceItems(archive.filmStock);
    await repos.filmRepo.replaceItems(archive.films);
    for (var thumbnailId in archive.thumbnails) {
      await repos.thumbnailRepo.import(
        temporaryFile: p.join(archive.thumbnailDirectory, thumbnailId),
        id: thumbnailId,
      );
    }
  }

  Future<ImportArchive?> loadArchive(String filename) async {
    final inputStream = InputFileStream(filename);
    try {
      final archive = ZipDecoder().decodeBuffer(inputStream);

      final cameras = _decodeArchiveEntry(
        file: archive.findFile('cameras.json'),
        key: 'cameras',
        fromJson: Camera.fromJson,
      );
      if (cameras == null) return null;

      final filmStock = _decodeArchiveEntry(
        file: archive.findFile('film_stock.json'),
        key: 'film_stock',
        fromJson: FilmStock.fromJson,
      );
      if (filmStock == null) return null;

      final lenses = _decodeArchiveEntry(
        file: archive.findFile('lenses.json'),
        key: 'lenses',
        fromJson: (json) => Lens.fromJson(json, cameras: cameras),
      );
      if (lenses == null) return null;

      final filters = _decodeArchiveEntry(
        file: archive.findFile('filters.json'),
        key: 'filters',
        fromJson: (json) => Filter.fromJson(json, lenses: lenses),
      );
      if (filters == null) return null;

      final films = _decodeArchiveEntry(
        file: archive.findFile('films.json'),
        key: 'films',
        fromJson: (json) => FilmInstance.fromJson(
          json,
          cameras: cameras,
          filmStock: filmStock,
          filters: filters,
          lenses: lenses,
        ),
      );
      if (films == null) return null;

      final cacheDir = await getApplicationCacheDirectory();
      final thumbnailDirectory = await cacheDir.createTemp();

      final thumbnails = await _extractThumbnails(
        archive: archive,
        dir: thumbnailDirectory.path,
      );

      return ImportArchive(
        basename: p.basename(filename),
        cameras: cameras,
        films: films,
        filmStock: filmStock,
        filters: filters,
        lenses: lenses,
        thumbnailDirectory: thumbnailDirectory.path,
        thumbnails: thumbnails,
      );
    } finally {
      await inputStream.close();
    }
  }
}

List<T>? _decodeArchiveEntry<T>({
  required ArchiveFile? file,
  required String key,
  required T Function(Map<String, dynamic>) fromJson,
}) {
  if (file == null) return null;

  try {
    final json = jsonDecode(String.fromCharCodes(file.content));

    return (json[key] as List<dynamic>)
        .map((j) => fromJson(j))
        .toList(growable: false);
  } catch (e) {
    print('import-service::decode-archive-entry: key=$key error: $e');
    return null;
  }
}

Future<List<String>> _extractThumbnails({
  required Archive archive,
  required String dir,
}) async {
  final List<String> ids = [];
  for (var file in archive.files) {
    if (file.name.startsWith('thumbnails/') && file.name.endsWith('.jpg')) {
      final filename = p.basename(file.name);
      final id = filename.replaceAll(RegExp(r'\.jpg$'), '');
      final dst = File(p.join(dir, id));
      await dst.create(recursive: true);
      await dst.writeAsBytes(file.content);
      ids.add(id);
    }
  }

  return ids;
}

class ImportArchive {
  const ImportArchive({
    required this.basename,
    required this.cameras,
    required this.films,
    required this.filmStock,
    required this.filters,
    required this.lenses,
    required this.thumbnailDirectory,
    required this.thumbnails,
  });

  final String basename;
  final List<Camera> cameras;
  final List<FilmInstance> films;
  final List<FilmStock> filmStock;
  final List<Filter> filters;
  final List<Lens> lenses;
  final String thumbnailDirectory;
  final List<String> thumbnails;
}
