import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:engineers_workshop/circuit_engine.dart';
import 'package:engineers_workshop/widgets/component_block.dart';
import 'package:engineers_workshop/widgets/wire_preview.dart';
import 'package:engineers_workshop/widgets/meter_readout.dart';

class CircuitCanvas extends StatefulWidget {
  final int selectedTool;
  final VoidCallback? onCircuitSolved;
  final CircuitCanvasController controller;
  const CircuitCanvas({
    super.key,
    required this.selectedTool,
    this.onCircuitSolved,
    required this.controller,
  });

  @override
  State<CircuitCanvas> createState() => _CircuitCanvasState();
}

/// Lets the parent (bench screen) drop components onto the canvas.
class CircuitCanvasController {
  _CircuitCanvasState? _state;
  void _attach(_CircuitCanvasState s) => _state = s;
  void _detach(_CircuitCanvasState s) {
    if (identical(_state, s)) _state = null;
  }

  bool get isAttached => _state != null;

  /// Place a new component of [type] at a sensible default spot.
  void placeComponent(ComponentType type) => _state?._placeComponentAuto(type);

  /// Remove everything from the bench.
  void clear() => _state?._clearCircuit();

  /// Number of components currently on the bench.
  int get blockCount => _state?._blocks.length ?? 0;
}

class _CircuitCanvasState extends State<CircuitCanvas> {
  final Circuit _circuit = Circuit();
  final List<ComponentBlock> _blocks = [];
  final List<WireConnection> _wires = [];
  final List<Meter> _meters = [];

  String? _wireStartTerminalId;
  Offset? _wireStartPos;
  Offset? _wireEndPos;

  bool _isDragging = false;
  ComponentBlock? _dragBlock;
  Offset _dragOffset = Offset.zero;

  int _blockCounter = 0;
  SolveResult? _lastSolve;

  @override
  void initState() {
    super.initState();
    widget.controller._attach(this);
  }

  @override
  void dispose() {
    widget.controller._detach(this);
    super.dispose();
  }

  /// Place a component at the next free slot in a simple flow layout.
  /// Layout runs left-to-right across the bench in rows, so a battery →
  /// resistor → lamp sequence lands in a sensible order to wire up.
  void _placeComponentAuto(ComponentType type) {
    final box = context.size;
    final w = box?.width ?? 360.0;
    final h = box?.height ?? 240.0;

    const padX = 90.0;
    const padY = 70.0;
    const stepX = 130.0;
    const stepY = 110.0;

    final cols = ((w - padX * 2) / stepX).floor().clamp(1, 8);
    final idx = _blocks.length;
    final col = idx % cols;
    final row = (idx ~/ cols) % 3;

    final x = padX + col * stepX;
    final y = padY + row * stepY;

    _addBlock(
      type,
      Offset(
        x.clamp(padX, w - padX),
        y.clamp(padY, h - padY),
      ),
    );
  }

  void _addBlock(ComponentType type, Offset position) {
    final id = 'block_${++_blockCounter}';
    final nodeP = _circuit.addNode('${id}_p');
    final nodeN = _circuit.addNode('${id}_n');
    Component comp;
    String label;
    double value;

    switch (type) {
      case ComponentType.battery:
        comp = VoltageSource(id, 9.0, '9V');
        label = '9V';
        value = 9.0;
        break;
      case ComponentType.resistor:
        comp = Resistor(id, 100.0, '100Ω');
        label = '100Ω';
        value = 100.0;
        break;
      case ComponentType.lamp:
        comp = Lamp(id, 50.0, 500.0, 0.1, 'Lamp');
        label = 'Lamp';
        value = 50.0;
        break;
      case ComponentType.wire:
        return;
    }

    comp.p.node = nodeP;
    comp.n.node = nodeN;

    final block = ComponentBlock(
      id: id,
      type: type,
      label: label,
      value: value,
      position: position,
      nodeP: nodeP,
      nodeN: nodeN,
      component: comp,
    );

    _circuit.addComponent(comp);
    setState(() => _blocks.add(block));
    _solve();
  }

  void _startWire(String terminalId, Offset position) {
    setState(() {
      _wireStartTerminalId = terminalId;
      _wireStartPos = position;
      _wireEndPos = position;
    });
  }

  void _updateWireEnd(Offset position) {
    setState(() => _wireEndPos = position);
  }

  void _endWire(String terminalId) {
    if (_wireStartTerminalId == null || _wireEndPos == null) return;
    if (_wireStartTerminalId == terminalId) {
      setState(() {
        _wireStartTerminalId = null;
        _wireStartPos = null;
        _wireEndPos = null;
      });
      return;
    }

    final wire = WireConnection(
      startTerminalId: _wireStartTerminalId!,
      endTerminalId: terminalId,
    );
    setState(() => _wires.add(wire));

    _connectTerminals(_wireStartTerminalId!, terminalId);
    setState(() {
      _wireStartTerminalId = null;
      _wireStartPos = null;
      _wireEndPos = null;
    });
    _solve();
  }

  void _connectTerminals(String tid1, String tid2) {
    final b1 = _blocks.firstWhere((b) => b.hasTerminal(tid1), orElse: () => throw StateError('No block'));
    final b2 = _blocks.firstWhere((b) => b.hasTerminal(tid2), orElse: () => throw StateError('No block'));
    final t1 = b1.terminalById(tid1);
    final t2 = b2.terminalById(tid2);
    if (t1 != null && t2 != null) {
      if (t1.node != null && t2.node != null) {
        t2.node = t1.node;
      } else if (t1.node != null) {
        t2.node = t1.node;
      } else if (t2.node != null) {
        t1.node = t2.node;
      } else {
        final node = _circuit.addNode('wire_${tid1}_$tid2');
        t1.node = node;
        t2.node = node;
      }
    }
  }

  void _solve() {
    final result = solve(_circuit);
    setState(() => _lastSolve = result);
    _updateLampStates();
    if (result.success) {
      widget.onCircuitSolved?.call();
    }
  }

  void _updateLampStates() {
    final result = _lastSolve;
    if (result == null || !result.success) return;
    for (final block in _blocks) {
      if (block.type == ComponentType.lamp) {
        final current = result.componentCurrent(block.id);
        block.updateLampState(current);
      }
    }
  }

  void _placeMeter(int meterType, Offset position) {
    final id = 'meter_${++_blockCounter}';
    final nodeP = _circuit.addNode('${id}_p');
    final nodeN = _circuit.addNode('${id}_n');
    final meter = Meter(
      id: id,
      type: meterType == 2 ? MeterType.voltmeter : MeterType.ammeter,
      position: position,
      nodeP: nodeP,
      nodeN: nodeN,
      label: meterType == 2 ? 'Voltmeter' : 'Ammeter',
    );
    setState(() => _meters.add(meter));
  }

  @override
  Widget build(BuildContext context) {
    final tool = widget.selectedTool;

    return GestureDetector(
      onTapDown: (details) {
        if (tool == 1) {
          final terminalId = _hitTestTerminal(details.localPosition);
          if (terminalId != null) {
            _startWire(terminalId, details.localPosition);
          }
        } else if (tool == 2 || tool == 3) {
          _placeMeter(tool, details.localPosition);
        } else if (tool == -1) {
          _clearCircuit();
        }
      },
      onPanStart: (details) {
        if (tool == 0) {
          final block = _hitTestBlock(details.localPosition);
          if (block != null) {
            setState(() {
              _isDragging = true;
              _dragBlock = block;
              _dragOffset = details.localPosition - block.position;
            });
          }
        }
        if (tool == 1 && _wireStartTerminalId != null) {
          _updateWireEnd(details.localPosition);
        }
      },
      onPanUpdate: (details) {
        if (_isDragging && _dragBlock != null) {
          setState(() {
            _dragBlock!.position = details.localPosition - _dragOffset;
          });
        }
        if (tool == 1 && _wireStartTerminalId != null) {
          _updateWireEnd(details.localPosition);
        }
      },
      onPanEnd: (details) {
        if (_isDragging) {
          setState(() {
            _isDragging = false;
            _dragBlock = null;
          });
        }
        if (tool == 1 && _wireStartTerminalId != null) {
          final terminalId = _hitTestTerminal(details.localPosition);
          _endWire(terminalId ?? _wireStartTerminalId!);
        }
      },
      child: Stack(
        children: [
          ..._wires.map((w) => WirePreview(
            startTerminalId: w.startTerminalId,
            endTerminalId: w.endTerminalId,
            blocks: _blocks,
          )),
          if (_wireStartTerminalId != null && _wireStartPos != null && _wireEndPos != null)
            WirePreview(
              startTerminalId: _wireStartTerminalId!,
              endTerminalId: 'temp',
              blocks: _blocks,
              tempEnd: _wireEndPos,
            ),
          ..._blocks.map((b) => b.build(
            onTerminalTap: (tid, pos) {
              if (tool == 1) {
                _startWire(tid, pos);
              }
            },
            isDragging: _isDragging && _dragBlock == b,
          )),
          ..._meters.map((m) => MeterReadout(
            meter: m,
            lastSolve: _lastSolve,
            blocks: _blocks,
            onTerminalTap: (tid, pos) {
              if (tool == 1) {
                _startWire(tid, pos);
              }
            },
          )),
        ],
      ),
    );
  }

  String? _hitTestTerminal(Offset pos) {
    for (final block in _blocks) {
      final tid = block.hitTestTerminal(pos);
      if (tid != null) return tid;
    }
    for (final meter in _meters) {
      final tid = meter.hitTestTerminal(pos);
      if (tid != null) return tid;
    }
    return null;
  }

  ComponentBlock? _hitTestBlock(Offset pos) {
    for (final block in _blocks) {
      if (block.hitTest(pos)) return block;
    }
    return null;
  }

  void _clearCircuit() {
    setState(() {
      _circuit.nodes.clear();
      _circuit.components.clear();
      _circuit.ground = null;
      _blocks.clear();
      _wires.clear();
      _meters.clear();
      _blockCounter = 0;
      _wireStartTerminalId = null;
      _wireStartPos = null;
      _wireEndPos = null;
      _lastSolve = null;
    });
  }
}

class WireConnection {
  final String startTerminalId;
  final String endTerminalId;
  WireConnection({required this.startTerminalId, required this.endTerminalId});
}
