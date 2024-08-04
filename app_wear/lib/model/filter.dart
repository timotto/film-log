import 'package:film_log_wear/model/util.dart';

import 'item.dart';
import 'lens.dart';

class Filter extends Item<Filter> {
  Filter({
    required this.id,
    required this.label,
    required this.lenses,
  });

  final String id;
  final String label;
  final List<Lens> lenses;

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'lenses': lenses.map((l) => l.toJson()).toList(),
      };

  @override
  String itemId() => id;

  @override
  String sortKey() => label;

  @override
  bool operator ==(Object other) =>
      other is Filter &&
      id == other.id &&
      label == other.label &&
      sameList(lenses, other.lenses);

  @override
  int get hashCode => Object.hashAll([id, label, ...lenses]);
}
