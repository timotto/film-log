import 'package:film_log_wear_data/model/equals.dart';
import 'package:film_log_wear_data/model/json.dart';
import 'package:film_log_wear_data/model/util.dart';

import 'photo.dart';

class Film implements ToJson, Equals<Film> {
  const Film({
    required this.id,
    required this.name,
    required this.inserted,
    required this.actualIso,
    required this.cameraId,
    required this.filmStockId,
    required this.photos,
    required this.maxPhotoCount,
    required this.lensIdList,
  });

  final String id;
  final String name;
  final DateTime inserted;
  final double? actualIso;
  final String? cameraId;
  final String? filmStockId;
  final List<Photo> photos;
  final int maxPhotoCount;
  final List<String> lensIdList;

  @override
  bool equals(Film other) =>
      id == other.id &&
      name == other.name &&
      inserted.isAtSameMomentAs(other.inserted) &&
      actualIso == other.actualIso &&
      cameraId == other.cameraId &&
      filmStockId == other.filmStockId &&
      Equals.all(photos, other.photos) &&
      maxPhotoCount == other.maxPhotoCount &&
      sameList(lensIdList, other.lensIdList);

  @override
  bool operator ==(Object other) =>
      other is Film &&
      id == other.id &&
      name == other.name &&
      inserted.isAtSameMomentAs(other.inserted) &&
      actualIso == other.actualIso &&
      cameraId == other.cameraId &&
      filmStockId == other.filmStockId &&
      Equals.all(photos, other.photos) &&
      maxPhotoCount == other.maxPhotoCount &&
      sameList(lensIdList, other.lensIdList);

  @override
  int get hashCode => Object.hashAll([
        id,
        name,
        inserted,
        actualIso,
        cameraId,
        filmStockId,
        ...photos,
        maxPhotoCount,
        ...lensIdList,
      ]);

  factory Film.fromJson(Map<String, dynamic> json) => Film(
        id: json['id'],
        name: json['name'],
        inserted: DateTime.parse(json['inserted']),
        actualIso: json['actualIso'],
        cameraId: json['cameraId'] as String,
        filmStockId: json['filmStockId'],
        photos: allFromJson(json['photos'], Photo.fromJson),
        maxPhotoCount: json['maxPhotoCount'],
        lensIdList: typedList<String>(json['lensIdList']),
      );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'inserted': inserted.toIso8601String(),
        'actualIso': actualIso,
        'cameraId': cameraId,
        'filmStockId': filmStockId,
        'photos': allToJson(photos),
        'maxPhotoCount': maxPhotoCount,
        'lensIdList': lensIdList,
      };
}
