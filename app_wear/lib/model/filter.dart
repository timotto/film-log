import 'gear.dart';
import 'lens.dart';

class Filter extends Gear<Filter> {
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
