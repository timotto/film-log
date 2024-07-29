import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/v4.dart';

import '../model/thumbnail.dart';

class ThumbnailRepo {
  late Directory _dir;

  Future<void> load() async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    _dir = Directory(p.join(appDir.path, 'thumbnails'));
    await _dir.create(recursive: true);
    print('thumbnail dir: ${_dir.path}');
  }

  Future<Thumbnail> store(String temporaryFile) async {
    final tmpFile = File(temporaryFile);
    final id = const UuidV4().generate();
    final dst = _filename(id);
    await tmpFile.copy(dst);
    await tmpFile.delete();

    return Thumbnail(id: id);
  }

  Future<void> delete(Thumbnail thumbnail) async {
    await file(thumbnail).delete();
  }

  File file(Thumbnail thumbnail) => File(_filename(thumbnail.id));

  String _filename(String id) => p.join(_dir.path, id);
}
