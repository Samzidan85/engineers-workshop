import 'components.dart';

/// Circuit description: a set of nodes, components, and a ground reference.
class Circuit {
  final List<Node> nodes = [];
  final List<Component> components = [];
  Node? ground;

  Node addNode(String id) {
    final n = Node(id);
    nodes.add(n);
    return n;
  }

  Component addComponent(Component c) {
    components.add(c);
    return c;
  }

  /// Sort nodes so that the ground node is always index 0.
  List<Node> get sortedNodes {
    final groundIndex = ground != null ? nodes.indexOf(ground!) : -1;
    final ordered = List<Node>.from(nodes);
    if (groundIndex > 0) {
      ordered.removeAt(groundIndex);
      ordered.insert(0, ground!);
    }
    return ordered;
  }

  /// Find a component by id.
  Component? findComponent(String id) {
    try {
      return components.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
