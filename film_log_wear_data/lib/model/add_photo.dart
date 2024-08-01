import 'package:film_log_wear_data/model/photo.dart';

class AddPhoto {
  const AddPhoto({
    required this.filmId,
    required this.photo,
  });

  final String filmId;
  final Photo photo;

  factory AddPhoto.fromJson(Map<String, dynamic> json) => AddPhoto(
        filmId: json['filmId'],
        photo: Photo.fromJson(json['photo']),
      );

  Map<String, dynamic> toJson() => {
        'filmId': filmId,
        'photo': photo.toJson(),
      };
}
