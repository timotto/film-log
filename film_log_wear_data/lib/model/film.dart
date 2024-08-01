import 'package:film_log_wear_data/model/json.dart';

import 'photo.dart';

class Film {
  const Film({
    required this.id,
    required this.name,
    required this.inserted,
    required this.cameraId,
    required this.photos,
    required this.maxPhotoCount,
    required this.lensIdList,
  });

  final String id;
  final String name;
  final DateTime inserted;
  final String? cameraId;
  final List<Photo> photos;
  final int maxPhotoCount;
  final List<String> lensIdList;

  factory Film.fromJson(Map<String, dynamic> json) => Film(
        id: json['id'],
        name: json['name'],
        inserted: DateTime.parse(json['inserted']),
        cameraId: json['cameraId'] as String,
        photos: (json['photos'] as List<dynamic>)
            .map((item) => Photo.fromJson(item))
            .toList(),
        maxPhotoCount: json['maxPhotoCount'],
        lensIdList: typedList<String>(json['lensIdList']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'inserted': inserted.toIso8601String(),
        'cameraId': cameraId,
        'photos': photos.map((item) => item.toJson()).toList(growable: false),
        'maxPhotoCount': maxPhotoCount,
        'lensIdList': lensIdList,
      };
}
