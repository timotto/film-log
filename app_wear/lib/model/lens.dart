import 'camera.dart';
import 'gear.dart';

class Lens extends Gear<Lens> {
  Lens({
    required this.id,
    required this.label,
    required this.apertures,
    required this.cameras,
  });

  final String id;
  final String label;
  final List<double> apertures;
  final List<Camera> cameras;

  @override
  String itemId() => id;
}
