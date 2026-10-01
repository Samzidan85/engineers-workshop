import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:engineers_workshop/theme.dart';
import 'package:engineers_workshop/progress.dart';
import 'package:engineers_workshop/widgets/bench_surface.dart';
import 'package:engineers_workshop/widgets/component_block.dart';
import 'package:engineers_workshop/widgets/tool_tray.dart';
import 'package:engineers_workshop/widgets/circuit_canvas.dart';

class CircuitBenchScreen extends StatefulWidget {
  const CircuitBenchScreen({super.key});

  @override
  State<CircuitBenchScreen> createState() => _CircuitBenchScreenState();
}

class _CircuitBenchScreenState extends State<CircuitBenchScreen> {
  int _selectedTool = 0; // 0=move, 1=wire, 2=voltmeter, 3=ammeter
  String? _hoveredTool;

  final CircuitCanvasController _canvas = CircuitCanvasController();
  final ProgressTracker _progress = ProgressTracker();
  bool _taskComplete = false;
  int _blockCount = 0;

  @override
  void initState() {
    super.initState();
    _progress.init().then((_) {
      if (mounted) {
        setState(() => _taskComplete =
            _progress.isMissionCompleted('build_basic_circuit'));
      }
    });
  }

  void _selectTool(int index) {
    setState(() => _selectedTool = index);
    HapticFeedback.lightImpact();
  }

  void _placeComponent(String kind) {
    final type = switch (kind) {
      'battery' => ComponentType.battery,
      'resistor' => ComponentType.resistor,
      'lamp' => ComponentType.lamp,
      _ => ComponentType.resistor,
    };
    _canvas.placeComponent(type);
    setState(() => _blockCount = _canvas.blockCount);
  }

  void _clearBench() {
    _canvas.clear();
    setState(() => _blockCount = 0);
  }

  /// Fired by CircuitCanvas when the solver finds a valid, closed circuit.
  void _onCircuitSolved() {
    if (_taskComplete) return;
    _taskComplete = true;
    _progress.completeMission('build_basic_circuit');
    _progress.earnBadge('first_circuit');
    setState(() {});
    HapticFeedback.mediumImpact();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF1A202C),
          content: Text(
            '💡 Circuit complete! +100 XP · Badge: First Circuit',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: BenchSurface()),
        Positioned.fill(
          child: Column(
            children: [
              _buildInstructionBanner(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: WorkshopColors.woodBorder,
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CircuitCanvas(
                              selectedTool: _selectedTool,
                              controller: _canvas,
                              onCircuitSolved: _onCircuitSolved,
                            ),
                          ),
                          if (_blockCount == 0)
                            const Positioned.fill(
                              child: IgnorePointer(child: _EmptyBenchHint()),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              ToolTray(
                selectedTool: _selectedTool,
                hoveredTool: _hoveredTool,
                onToolSelected: _selectTool,
                onToolHover: (tool) => setState(() => _hoveredTool = tool),
                onPlaceComponent: _placeComponent,
                onClear: _clearBench,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: WorkshopColors.ironDark.withOpacity(0.85),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: WorkshopColors.brassDark, width: 1),
      ),
      child: Row(
        children: [
          Icon(
            _taskComplete ? Icons.check_circle : Icons.lightbulb_outline,
            color: _taskComplete
                ? WorkshopColors.meterTextGreen
                : WorkshopColors.brass,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _blockCount == 0
                  ? 'Task 1 — Light the bulb. Tap Battery, Resistor and Lamp below to place them, then pick the Wire tool and tap a + terminal followed by a − terminal.'
                  : 'Wire the parts into a loop: battery + → lamp −, lamp + → resistor −, resistor + → battery −. The lamp lights when the loop closes.',
              style: const TextStyle(
                color: WorkshopColors.ironText,
                fontSize: 12,
                height: 1.3,
              ),
            ),
          ),
          if (_blockCount > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: WorkshopColors.brass.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: WorkshopColors.brassDark),
              ),
              child: Text(
                _taskComplete ? 'Complete ✓' : '$_blockCount parts',
                style: TextStyle(
                  color: _taskComplete
                      ? WorkshopColors.meterTextGreen
                      : WorkshopColors.brass,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyBenchHint extends StatelessWidget {
  const _EmptyBenchHint();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.construction,
            size: 40,
            color: Colors.white.withOpacity(0.25),
          ),
          const SizedBox(height: 10),
          Text(
            'Empty bench',
            style: TextStyle(
              color: Colors.white.withOpacity(0.45),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap a component below to place it',
            style: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
