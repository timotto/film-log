import 'gear.dart';

class Camera extends Gear<Camera> {
  const Camera({
    required this.id,
    required this.label,
    required this.shutterSpeeds,
  });

  final String id;
  final String label;
  final List<double> shutterSpeeds;

  @override
  String itemId() => id;
}
