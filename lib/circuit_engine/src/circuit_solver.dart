import 'circuit.dart';
import 'result.dart';
import 'components.dart' as c;

/// Solve a DC circuit using modified nodal analysis (MNA).
SolveResult solve(Circuit circuit) {
  try {
    return _solveMNA(circuit);
  } catch (e) {
    return SolveResult.error('Solver error: $e');
  }
}

SolveResult _solveMNA(Circuit circuit) {
  final nodesList = circuit.sortedNodes;
  if (nodesList.isEmpty) {
    return SolveResult.empty();
  }

  final nodeIndex = <c.Node, int>{};
  for (int i = 0; i < nodesList.length; i++) {
    nodeIndex[nodesList[i]] = i;
  }
  final nNodes = nodesList.length;

  final present = circuit.components.where((comp) => comp.present).toList();
  final vsources = present.whereType<c.VoltageSource>().toList();
  final nVS = vsources.length;

  final size = nNodes + nVS;
  final A = List<List<double>>.generate(size, (_) => List<double>.filled(size, 0.0));
  final b = List<double>.filled(size, 0.0);

  // Fill the conductance matrix
  for (final comp in present) {
    if (comp is c.VoltageSource) continue;
    final g = _conductanceOf(comp);
    if (g == null) continue;
    final nP = nodeIndex[comp.p.node]!;
    final nN = nodeIndex[comp.n.node]!;
    A[nP][nP] += g;
    A[nN][nN] += g;
    A[nP][nN] -= g;
    A[nN][nP] -= g;
  }

  // Voltage source constraints
  for (int k = 0; k < nVS; k++) {
    final vs = vsources[k];
    final nP = nodeIndex[vs.p.node]!;
    final nN = nodeIndex[vs.n.node]!;
    final col = nNodes + k;

    A[nP][col] = 1.0;
    A[nN][col] = -1.0;
    A[col][nP] = 1.0;
    A[col][nN] = -1.0;

    b[col] = vs.value;
  }

  // Fix ground reference: V(ground) = 0 replaces the dependent ground KCL row
  if (nNodes > 0) {
    A[0][0] = 1.0;
    for (int j = 1; j < size; j++) {
      A[0][j] = 0.0;
    }
    b[0] = 0.0;
  }

  final x = _solveLinear(A, b);
  if (x == null) {
    return SolveResult.error('No unique solution — check your wiring.');
  }

  // Extract voltages
  final nodeVoltages = <String, double>{};
  for (int i = 0; i < nNodes; i++) {
    nodeVoltages[nodesList[i].id] = x[i];
  }

  // Extract branch currents for VS
  final vsCurrents = <String, double>{};
  for (int k = 0; k < nVS; k++) {
    vsCurrents[vsources[k].id] = x[nNodes + k];
  }

  // Set component voltages and currents
  for (final comp in present) {
    if (comp is c.VoltageSource) {
      comp.current = vsCurrents[comp.id] ?? 0.0;
      comp.voltage = comp.value;
    } else {
      final nP = nodeIndex[comp.p.node]!;
      final nN = nodeIndex[comp.n.node]!;
      final vDiff = x[nP] - x[nN];
      comp.voltage = vDiff;
      final g = _conductanceOf(comp);
      comp.current = g != null ? vDiff * g : 0.0;
    }
  }

  // Update state-dependent components
  for (final comp in present) {
    if (comp is c.Lamp) {
      comp.updateState(comp.current);
    } else if (comp is c.Diode) {
      comp.updateState(comp.voltage, comp.current);
    } else if (comp is c.Fuse) {
      if (comp.current.abs() > comp.rating) {
        comp.blown = true;
      }
    }
  }

  return SolveResult.ok(
    nodeVoltages: nodeVoltages,
    branchCurrents: vsCurrents,
    components: present,
    groundNode: circuit.ground,
  );
}

double? _conductanceOf(c.Component comp) {
  if (comp is c.Resistor) {
    if (comp.value <= 0) return null;
    return 1.0 / comp.value;
  }
  if (comp is c.Diode && comp.on) {
    return 1.0 / comp.onResistance;
  }
  if (comp is c.Lamp) {
    if (comp.value <= 0) return null;
    return 1.0 / comp.value;
  }
  if (comp is c.Fuse) {
    if (comp.value <= 0) return null;
    return 1.0 / comp.value;
  }
  return null;
}

/// Solve Ax = b via Gaussian elimination with partial pivoting.
List<double>? _solveLinear(List<List<double>> A, List<double> b) {
  final n = A.length;
  if (n == 0) return b;
  final M = List<List<double>>.generate(n, (i) => [...A[i], b[i]]);

  for (int col = 0; col < n; col++) {
    int best = col;
    double bestVal = M[col][col].abs();
    for (int row = col + 1; row < n; row++) {
      final v = M[row][col].abs();
      if (v > bestVal) {
        bestVal = v;
        best = row;
      }
    }
    if (bestVal < 1e-15) return null;
    if (best != col) {
      final tmp = M[col];
      M[col] = M[best];
      M[best] = tmp;
    }
    final pivot = M[col][col];
    for (int row = col + 1; row < n; row++) {
      final factor = M[row][col] / pivot;
      for (int k = col; k <= n; k++) {
        M[row][k] -= factor * M[col][k];
      }
    }
  }

  final x = List<double>.filled(n, 0.0);
  for (int i = n - 1; i >= 0; i--) {
    double sum = M[i][n];
    for (int j = i + 1; j < n; j++) {
      sum -= M[i][j] * x[j];
    }
    x[i] = sum / M[i][i];
  }
  return x;
}
