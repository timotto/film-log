import 'package:film_log_wear_data/model/json.dart';

class Filter {
  const Filter({
    required this.id,
    required this.label,
    required this.lensIdList,
  });

  final String id;
  final String label;
  final List<String> lensIdList;

  factory Filter.fromJson(Map<String, dynamic> json) => Filter(
        id: json['id'],
        label: json['label'],
        lensIdList: typedList<String>(json['lensIdList']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'lensIdList': lensIdList,
      };
}
