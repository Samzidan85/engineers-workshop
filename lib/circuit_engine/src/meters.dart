import 'components.dart';

/// Meters: read circuit values.
class IdealMeter {
  static double measureVoltage(Map<String, double> nodeVoltages, String nodeP, String nodeN) {
    return (nodeVoltages[nodeP] ?? 0.0) - (nodeVoltages[nodeN] ?? 0.0);
  }

  static double measureCurrent(List<Component> components, String componentId) {
    final c = components.firstWhere(
      (x) => x.id == componentId,
      orElse: () => throw StateError('Unknown component: $componentId'),
    );
    return c.current;
  }
}
