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

  @override
  String itemId() => id;
}
