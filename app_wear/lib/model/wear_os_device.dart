class WearOsDevice {
  const WearOsDevice({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  @override
  bool operator ==(Object other) =>
      other is WearOsDevice && id == other.id && name == other.name;

  @override
  int get hashCode => Object.hashAll([id, name]);
}
