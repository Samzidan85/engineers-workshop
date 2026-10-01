import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:engineers_workshop/theme.dart';
import 'package:engineers_workshop/progress.dart';
import 'package:engineers_workshop/widgets/bench_surface.dart';
import 'package:engineers_workshop/widgets/tool_tray.dart';
import 'package:engineers_workshop/widgets/circuit_canvas.dart';

class CircuitBenchScreen extends StatefulWidget {
  const CircuitBenchScreen({super.key});

  @override
  State<CircuitBenchScreen> createState() => _CircuitBenchScreenState();
}

class _CircuitBenchScreenState extends State<CircuitBenchScreen> {
  int _selectedTool = 0; // 0=select, 1=wire, 2=voltmeter, 3=ammeter
  String? _hoveredTool;

  final ProgressTracker _progress = ProgressTracker();
  bool _taskComplete = false;

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
        // Bench surface background
        const BenchSurface(),
        // Main content: circuit canvas + tools
        Positioned.fill(
          child: Column(
            children: [
              // Instruction banner
              _buildInstructionBanner(),
              // Circuit canvas (working area)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: CircuitCanvas(
                    selectedTool: _selectedTool,
                    onCircuitSolved: _onCircuitSolved,
                  ),
                ),
              ),
              // Tool tray
              ToolTray(
                selectedTool: _selectedTool,
                hoveredTool: _hoveredTool,
                onToolSelected: _selectTool,
                onToolHover: (tool) => setState(() => _hoveredTool = tool),
              ),
            ],
          ),
        ),
        // Top bar: back button + task description
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _buildTopBar(),
        ),
      ],
    );
  }

  Widget _buildInstructionBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: WorkshopColors.ironDark.withOpacity(0.85),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: WorkshopColors.brassDark, width: 1),
      ),
      child: const Row(
        children: [
          Icon(Icons.lightbulb_outline, color: WorkshopColors.brass, size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Drag components from the tray onto the bench. Tap a terminal to start a wire, then tap another terminal to connect.',
              style: TextStyle(
                color: WorkshopColors.ironText,
                fontSize: 13,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: WorkshopColors.woodDark.withOpacity(0.95),
        border: Border(
          bottom: BorderSide(color: WorkshopColors.woodBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, color: Colors.white70),
            tooltip: 'Back to workshop',
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'L1 · The Circuit Bench',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: WorkshopColors.brass.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: WorkshopColors.brassDark),
            ),
            child: Text(
              _taskComplete ? 'Task 1: Complete ✓' : 'Task 1: Light the bulb',
              style: TextStyle(
                color: _taskComplete
                    ? WorkshopColors.meterTextGreen
                    : WorkshopColors.brass,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
