import 'package:film_log_wear_data/model/json.dart';

class Camera {
  const Camera({
    required this.id,
    required this.label,
    required this.shutterSpeeds,
  });

  final String id;
  final String label;
  final List<double> shutterSpeeds;

  factory Camera.fromJson(Map<String, dynamic> json) => Camera(
        id: json['id'],
        label: json['label'],
        shutterSpeeds: typedList<double>(json['shutterSpeeds']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'shutterSpeeds': shutterSpeeds,
      };
}
