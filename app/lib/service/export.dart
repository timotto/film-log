import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../model/film_instance.dart';
import '../model/json.dart';
import 'repos.dart';

class ExportService {
  const ExportService({required this.repos});

  final Repos repos;

  Future<void> exportAll(Future<void> Function(String) cb) async {
    final tempDir = await _createTempDir();
    final zipFilename = p.join(tempDir.path, 'film-log-export-all.zip');

    try {
      await _withTempDirectory(
        name: 'film-log-export',
        fn: (dir) async {
          await _writeItemsJsonFile(
            dir: dir,
            filename: 'cameras.json',
            key: 'cameras',
            items: repos.cameraRepo.items(),
          );

          await _writeItemsJsonFile(
            dir: dir,
            filename: 'film_stock.json',
            key: 'film_stock',
            items: repos.filmstockRepo.items(),
          );

          await _writeItemsJsonFile(
            dir: dir,
            filename: 'filters.json',
            key: 'filters',
            items: repos.filterRepo.items(),
          );

          await _writeItemsJsonFile(
            dir: dir,
            filename: 'lenses.json',
            key: 'lenses',
            items: repos.lensRepo.items(),
          );

          await _writeJsonFile(
            dir: dir,
            filename: 'films.json',
            data: {
              'films': repos.filmRepo
                  .items()
                  .map((item) => item.toJsonExport())
                  .toList(growable: false),
            },
          );

          for (var film in repos.filmRepo.items()) {
            await _exportThumbnails(
              dir: Directory(p.join(
                dir.path,
                'thumbnails',
                'film-${film.id}',
              )),
              film: film,
            );
          }

          await ZipFileEncoder().zipDirectoryAsync(
            dir,
            filename: zipFilename,
          );
        },
      );

      await cb(zipFilename);
    } finally {
      await tempDir.delete(recursive: true);
    }
  }

  Future<void> exportFilm(
    FilmInstance film,
    Future<void> Function(String) cb,
  ) async {
    final tempDir = await _createTempDir();
    final zipFilename = p.join(tempDir.path, 'film-log-export.zip');

    try {
      await _withTempDirectory(
        name: 'film-log-export',
        fn: (dir) async {
          await _writeJsonFile(
            dir: dir,
            filename: 'film.json',
            data: film.toJson(),
          );

          await _exportThumbnails(
            dir: Directory(p.join(dir.path, 'thumbnails')),
            film: film,
          );

          await ZipFileEncoder().zipDirectoryAsync(
            dir,
            filename: zipFilename,
          );
        },
      );

      await cb(zipFilename);
    } finally {
      await tempDir.delete(recursive: true);
    }
  }

  Future<void> _exportThumbnails({
    required Directory dir,
    required FilmInstance film,
  }) async {
    for (var photo in film.photos) {
      final thumbnail = photo.thumbnail;
      if (thumbnail == null) continue;
      final filename = p.join(
        dir.path,
        'photo-${photo.id}',
        '${thumbnail.id}.jpg',
      );

      await File(filename).create(recursive: true);

      await repos.thumbnailRepo.file(thumbnail).copy(filename);
    }
  }

  Future<T> _withTempDirectory<T>({
    String? prefix,
    required String name,
    required Future<T> Function(Directory) fn,
  }) async {
    final cacheDir = await getApplicationCacheDirectory();
    final tempDir = await cacheDir.createTemp(prefix);
    final dir = Directory(p.join(tempDir.path, name));
    await dir.create();

    try {
      return await fn(dir);
    } finally {
      await tempDir.delete(recursive: true);
    }
  }

  Future<Directory> _createTempDir() async {
    final cacheDir = await getApplicationCacheDirectory();
    final tempDir = await cacheDir.createTemp();

    return tempDir;
  }
}

Future<void> _writeItemsJsonFile<T extends ToJson>({
  required Directory dir,
  required String filename,
  required String key,
  required List<T> items,
}) async {
  await _writeJsonFile(
    dir: dir,
    filename: filename,
    data: {key: _allToJson(items)},
  );
}

Future<void> _writeJsonFile<T extends ToJson>({
  required Directory dir,
  required String filename,
  required Map<String, dynamic> data,
}) async {
  final file = await File(p.join(dir.path, filename)).create(recursive: true);
  final json = jsonEncode(data);
  await file.writeAsString(json);
}

List<Map<String, dynamic>> _allToJson<T extends ToJson>(Iterable<T> items) =>
    items.map((item) => item.toJson()).toList(growable: false);
