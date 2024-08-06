import 'package:film_log/model/equals.dart';
import 'package:film_log/model/film_stock.dart';
import 'package:film_log/model/filter.dart';
import 'package:film_log/model/json.dart';
import 'package:uuid/v4.dart';

import 'camera.dart';
import 'lens.dart';
import 'photo.dart';

class FilmInstance implements ToJson, Equals<FilmInstance> {
  final String id;
  final String name;
  final DateTime inserted;
  final FilmStock? stock;
  final double actualIso;
  final Camera? camera;
  final List<Photo> photos;
  final int maxPhotoCount;
  final bool archive;

  FilmInstance({
    required this.id,
    required this.name,
    required this.inserted,
    required this.stock,
    required this.actualIso,
    required this.camera,
    required this.photos,
    required this.maxPhotoCount,
    required this.archive,
  });

  factory FilmInstance.createNew({
    Camera? camera,
    FilmStock? filmStock,
    double? actualIso,
    int? maxPhotoCount,
  }) =>
      FilmInstance(
        id: const UuidV4().generate(),
        name: '',
        inserted: DateTime.timestamp(),
        stock: filmStock,
        actualIso: actualIso ?? 100,
        camera: camera,
        photos: [],
        maxPhotoCount: maxPhotoCount ?? 10,
        archive: false,
      );

  String itemId() => id;

  bool validate() =>
      name.isNotEmpty && maxPhotoCount > 0 && photos.length <= maxPhotoCount;

  @override
  bool equals(FilmInstance other) =>
      id == other.id &&
      name == other.name &&
      inserted.isAtSameMomentAs(other.inserted) &&
      stock == other.stock &&
      actualIso == other.actualIso &&
      Equals.orNull(camera, other.camera) &&
      Equals.all(photos, other.photos) &&
      maxPhotoCount == other.maxPhotoCount &&
      archive == other.archive;

  FilmInstance update({
    String? id,
    String? name,
    DateTime? inserted,
    FilmStock? stock,
    double? actualIso,
    Camera? camera,
    List<Photo>? photos,
    int? maxPhotoCount,
    bool? archive,
  }) =>
      FilmInstance(
        id: id ?? this.id,
        name: name ?? this.name,
        inserted: inserted ?? this.inserted,
        stock: stock ?? this.stock,
        actualIso: actualIso ?? this.actualIso,
        camera: camera ?? this.camera,
        photos: photos ?? this.photos,
        maxPhotoCount: maxPhotoCount ?? this.maxPhotoCount,
        archive: archive ?? this.archive,
      );

  FilmInstance addPhoto(Photo photo) => update(
        photos: [...photos.where((p) => p.id != photo.id), photo.ensureId()],
      );

  factory FilmInstance.fromJson(
    Map<String, dynamic> json, {
    required List<FilmStock> filmStock,
    required List<Camera> cameras,
    required List<Filter> filters,
    required List<Lens> lenses,
  }) =>
      FilmInstance(
        id: json['id'],
        name: json['name'],
        inserted: DateTime.parse(json['inserted']),
        stock: json['stock'] != null
            ? filmStock.where((f) => f.id == json['stock']).first
            : null,
        actualIso: json['actualIso'],
        camera: json['camera'] != null
            ? cameras.where((c) => c.id == json['camera']).first
            : null,
        photos: (json['photos'] as List<dynamic>)
            .map((p) => Photo.fromJson(
                  p,
                  filters: filters,
                  lenses: lenses,
                ))
            .toList(),
        maxPhotoCount: json['maxPhotoCount'],
        archive: json['archive'] ?? false,
      );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'inserted': inserted.toIso8601String(),
        if (stock != null) 'stock': stock!.id,
        'actualIso': actualIso,
        if (camera != null) 'camera': camera!.id,
        'photos': photos.map((p) => p.toJson()).toList(growable: false),
        'maxPhotoCount': maxPhotoCount,
        if (archive) 'archive': archive,
      };

  Map<String, dynamic> toJsonExport() => {
        'id': id,
        'name': name,
        'inserted': inserted.toIso8601String(),
        if (stock != null) 'stock': stock!.toJson(),
        'actualIso': actualIso,
        if (camera != null) 'camera': camera!.toJson(),
        'photos': photos.map((p) => p.toJsonExport()).toList(growable: false),
        'maxPhotoCount': maxPhotoCount,
        if (archive) 'archive': archive,
      };
}
