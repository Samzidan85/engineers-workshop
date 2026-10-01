import 'components.dart';

/// Result of a circuit solve.
class SolveResult {
  final bool success;
  final Map<String, double>? nodeVoltages;
  final Map<String, double>? branchCurrents;
  final List<Component>? components;
  final Node? groundNode;
  final String? errorMessage;

  SolveResult._({
    required this.success,
    this.nodeVoltages,
    this.branchCurrents,
    this.components,
    this.groundNode,
    this.errorMessage,
  });

  factory SolveResult.ok({
    required Map<String, double> nodeVoltages,
    required Map<String, double> branchCurrents,
    required List<Component> components,
    Node? groundNode,
  }) {
    return SolveResult._(
      success: true,
      nodeVoltages: nodeVoltages,
      branchCurrents: branchCurrents,
      components: components,
      groundNode: groundNode,
    );
  }

  factory SolveResult.error(String message) {
    return SolveResult._(success: false, errorMessage: message);
  }

  factory SolveResult.empty() {
    return SolveResult._(success: true, nodeVoltages: {}, branchCurrents: {}, components: []);
  }

  double nodeVoltage(String nodeId) => nodeVoltages?[nodeId] ?? 0.0;
  double componentVoltage(String id) => components?.firstWhere((x) => x.id == id)?.voltage ?? 0.0;
  double componentCurrent(String id) => components?.firstWhere((x) => x.id == id)?.current ?? 0.0;
  List<MapEntry<String, double>> sortedNodeVoltages() {
    if (nodeVoltages == null) return [];
    final sorted = nodeVoltages!.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted;
  }
}
