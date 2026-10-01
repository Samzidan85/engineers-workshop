import 'dart:math';

/// A node in the circuit.
class Node {
  final String id;
  Node(this.id);
}

/// Terminal on a component: connects to a circuit node.
class Terminal {
  final String name;
  Node? node;

  Terminal(this.name, [this.node]);
}

/// A two-terminal circuit component.
abstract class Component {
  String get id;
  Terminal get p;
  Terminal get n;
  double get value;
  String get label;

  /// Current through the component (positive from p to n), set by the solver.
  double current = 0.0;

  /// Voltage across p−n, set by the solver.
  double voltage = 0.0;

  /// Whether the component is present in the circuit.
  bool get present => true;
}

/// Voltage source: fixes the voltage between its terminals.
class VoltageSource extends Component {
  @override
  final String id;
  @override
  final Terminal p = Terminal('+');
  @override
  final Terminal n = Terminal('−');
  @override
  final double value;
  final String _label;

  VoltageSource(this.id, this.value, [String label = ''])
      : _label = label.isEmpty ? 'VS' : label;

  @override
  String get label => _label;
}

/// Resistor in ohms.
class Resistor extends Component {
  @override
  final String id;
  @override
  final Terminal p = Terminal('A');
  @override
  final Terminal n = Terminal('B');
  @override
  final double value;
  final String _label;

  Resistor(this.id, this.value, [String label = ''])
      : _label = label.isEmpty ? '${value.round()}Ω' : label;

  @override
  String get label => _label;
}

/// Capacitor in farads (open in DC steady state).
class Capacitor extends Component {
  @override
  final String id;
  @override
  final Terminal p = Terminal('A');
  @override
  final Terminal n = Terminal('B');
  @override
  final double value;
  final String _label;

  Capacitor(this.id, this.value, [String label = ''])
      : _label = label.isEmpty ? '${value.round()}F' : label;

  @override
  bool get present => false;
  @override
  String get label => _label;
}

/// Inductor in henries (short in DC steady state).
class Inductor extends Component {
  @override
  final String id;
  @override
  final Terminal p = Terminal('A');
  @override
  final Terminal n = Terminal('B');
  @override
  final double value;
  final String _label;

  Inductor(this.id, this.value, [String label = ''])
      : _label = label.isEmpty ? '${value.round()}H' : label;

  @override
  bool get present => true;
  @override
  String get label => _label;
}

/// Ideal switch.
class Switch extends Component {
  @override
  final String id;
  @override
  final Terminal p = Terminal('1');
  @override
  final Terminal n = Terminal('2');
  @override
  double get value => 0.0;
  final String _label;
  bool _open = true;

  Switch(this.id, [String label = ''])
      : _label = label.isEmpty ? 'Switch' : label;

  bool get open => _open;
  set open(bool v) => _open = v;
  @override
  bool get present => !_open;
  @override
  String get label => _label;
}

/// Fuse that opens when current exceeds rating.
class Fuse extends Component {
  @override
  final String id;
  @override
  final Terminal p = Terminal('A');
  @override
  final Terminal n = Terminal('B');
  @override
  final double value;
  final double rating;
  final String _label;
  bool _blown = false;

  Fuse(this.id, this.value, this.rating, [String label = ''])
      : _label = label.isEmpty ? 'Fuse' : label;

  bool get blown => _blown;
  set blown(bool v) => _blown = v;
  @override
  bool get present => !_blown;
  @override
  String get label => _label;
}

/// Lamp: incandescent bulb modeled as a resistor that changes with current.
class Lamp extends Component {
  @override
  final String id;
  @override
  final Terminal p = Terminal('A');
  @override
  final Terminal n = Terminal('B');
  final double coldR;
  final double hotR;
  final double nominalCurrent;
  final String _label;
  bool _on = false;

  Lamp(this.id, this.coldR, this.hotR, this.nominalCurrent, [String label = ''])
      : _label = label.isEmpty ? 'Lamp' : label;

  @override
  bool get present => true;
  @override
  double get value => _on ? hotR : coldR;

  @override
  String get label => _label;

  void updateState(double current) {
    _on = current.abs() >= nominalCurrent * 0.5;
  }
}

/// Simplified diode.
class Diode extends Component {
  @override
  final String id;
  @override
  final Terminal p = Terminal('A');
  @override
  final Terminal n = Terminal('B');
  @override
  double get value => on ? onResistance : double.infinity;
  final double threshold;
  final double onResistance;
  final String _label;
  bool _on = false;

  Diode(this.id, {this.threshold = 0.7, this.onResistance = 0.1, String label = ''})
      : _label = label.isEmpty ? 'Diode' : label;

  bool get on => _on;
  set on(bool v) => _on = v;
  @override
  bool get present => _on;
  @override
  String get label => _label;

  void updateState(double v, double i) {
    _on = v > threshold && i.abs() > 1e-6;
  }
}
