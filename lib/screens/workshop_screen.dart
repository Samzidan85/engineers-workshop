import 'package:flutter/material.dart';
import 'package:engineers_workshop/widgets/workshop_header.dart';
import 'package:engineers_workshop/widgets/level_selector.dart';
import 'package:engineers_workshop/screens/circuit_bench_screen.dart';

class WorkshopScreen extends StatefulWidget {
  const WorkshopScreen({super.key});

  @override
  State<WorkshopScreen> createState() => _WorkshopScreenState();
}

class _WorkshopScreenState extends State<WorkshopScreen> {
  int _currentLevel = 1;

  void _openLevel(int level) {
    setState(() => _currentLevel = level);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4A3728),
              Color(0xFF3A2A1C),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const WorkshopHeader(),
              const SizedBox(height: 12),
              LevelSelector(
                currentLevel: _currentLevel,
                onLevelSelected: _openLevel,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _buildLevelContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelContent() {
    switch (_currentLevel) {
      case 1:
        return const CircuitBenchScreen();
      default:
        return const Center(
          child: Text(
            'Level coming soon',
            style: TextStyle(color: Colors.white70, fontSize: 20),
          ),
        );
    }
  }
}
