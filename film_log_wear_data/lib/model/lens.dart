import 'package:film_log_wear_data/model/json.dart';

class Lens {
  const Lens({
    required this.id,
    required this.label,
    required this.apertures,
    required this.cameraIds,
  });

  final String id;
  final String label;
  final List<double> apertures;
  final List<String> cameraIds;

  factory Lens.fromJson(Map<String, dynamic> json) => Lens(
        id: json['id'],
        label: json['label'],
        apertures: typedList<double>(json['apertures']),
        cameraIds: typedList<String>(json['cameraIds']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'apertures': apertures,
        'cameraIds': cameraIds,
      };
}
