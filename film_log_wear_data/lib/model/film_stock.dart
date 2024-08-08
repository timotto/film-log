import 'package:film_log_wear_data/model/json.dart';

class FilmStock {
  const FilmStock({
    required this.id,
    required this.label,
    required this.iso,
    required this.cameraIds,
  });

  final String id;
  final String label;
  final double iso;
  final List<String> cameraIds;

  factory FilmStock.fromJson(Map<String, dynamic> json) => FilmStock(
        id: json['id'],
        label: json['label'],
        iso: json['iso'],
        cameraIds: typedList(json['cameraIds']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'iso': iso,
        'cameraIds': cameraIds,
      };
}
