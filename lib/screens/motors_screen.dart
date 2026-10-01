import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:engineers_workshop/theme.dart' as th;

/// Level 2: DC Motor Simulation
/// Simulates a permanent-magnet DC motor with realistic physics.
class MotorsScreen extends StatefulWidget {
  const MotorsScreen({super.key});

  @override
  State<MotorsScreen> createState() => _MotorsScreenState();
}

class _MotorsScreenState extends State<MotorsScreen>
    with SingleTickerProviderStateMixin {
  // --- Motor parameters (simplified but realistic) ---
  static const double _armatureResistance = 0.8; // Ohms
  static const double _motorConstant = 0.045; // V/(rad/s) — back-EMF constant
  static const double _maxCurrent = 30.0; // Amps (stall current at 48V)
  static const double _maxTorque = 1.35; // N·m (k * I_stall)

  // --- User-controlled inputs ---
  double _voltage = 24.0; // 0–48 V
  double _loadPercent = 30.0; // 0–100 %

  // --- Animation ---
  late AnimationController _rotorController;

  // --- Computed motor state ---
  double _speedRpm = 0;
  double _armatureCurrent = 0;
  double _torque = 0;
  double _electricalPower = 0;
  double _mechanicalPower = 0;
  double _efficiency = 0;
  String _motorState = 'Stopped';

  @override
  void initState() {
    super.initState();
    _rotorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _recalculate();
  }

  @override
  void dispose() {
    _rotorController.dispose();
    super.dispose();
  }

  /// Core DC motor physics.
  ///
  /// Model: V = E + I*R  where  E = k * ω
  ///   → ω = (V - I*R) / k
  ///   → Torque = k * I
  /// Load torque is proportional to loadPercent.
  /// At steady state, motor torque = load torque.
  void _recalculate() {
    // Load torque: 0 at 0%, _maxTorque at 100%
    final double loadTorque = (_loadPercent / 100.0) * _maxTorque;

    // Solve for current where motor torque equals load torque:
    //   k * I = loadTorque  →  I = loadTorque / k
    double current = loadTorque / _motorConstant;

    // Stall current (when ω = 0): I_stall = V / R
    final double stallCurrent = _voltage / _armatureResistance;

    // Clamp current to stall current (motor can't draw more)
    if (current > stallCurrent) {
      current = stallCurrent;
    }

    // Back-EMF: E = V - I*R
    final double backEmf = _voltage - current * _armatureResistance;

    // Angular velocity: ω = E / k  (rad/s)
    final double omega = backEmf / _motorConstant;

    // Convert to RPM
    final double rpm = omega * 60.0 / (2 * math.pi);

    // Torque produced
    final double torque = _motorConstant * current;

    // Powers
    final double pElectrical = _voltage * current;
    final double pMechanical = torque * omega;

    // Efficiency
    double eff = 0;
    if (pElectrical > 0.01) {
      eff = (pMechanical / pElectrical) * 100.0;
      if (eff > 100) eff = 100;
      if (eff < 0) eff = 0;
    }

    // Motor state
    String state;
    if (_voltage < 1.0) {
      state = 'Stopped';
    } else if (rpm < 50) {
      state = 'Stalled';
    } else if (current > stallCurrent * 0.85) {
      state = 'Overloaded';
    } else {
      state = 'Running';
    }

    setState(() {
      _speedRpm = rpm;
      _armatureCurrent = current;
      _torque = torque;
      _electricalPower = pElectrical;
      _mechanicalPower = pMechanical;
      _efficiency = eff;
      _motorState = state;
    });

    // Update rotor animation speed (map RPM to rotation duration)
    if (rpm > 1) {
      // Clamp animation speed so it doesn't get too fast or too slow
      final double durationMs = (60000.0 / rpm).clamp(16.0, 2000.0);
      _rotorController.duration = Duration(milliseconds: durationMs.round());
      if (!_rotorController.isAnimating) {
        _rotorController.repeat();
      }
    } else {
      _rotorController.stop();
    }
  }

  Color _stateColor() {
    switch (_motorState) {
      case 'Running':
        return const Color(0xFF48BB78);
      case 'Stalled':
        return const Color(0xFFE53E3E);
      case 'Overloaded':
        return const Color(0xFFECC94B);
      default:
        return th.WorkshopColors.ironText;
    }
  }

  IconData _stateIcon() {
    switch (_motorState) {
      case 'Running':
        return Icons.check_circle;
      case 'Stalled':
        return Icons.warning;
      case 'Overloaded':
        return Icons.error;
      default:
        return Icons.power_settings_new;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080c11),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111820),
        title: const Text(
          'L2 · DC Motor Lab',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white70),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Motor visual ---
            _buildMotorVisual(),
            const SizedBox(height: 16),
            // --- State indicator ---
            _buildStateIndicator(),
            const SizedBox(height: 16),
            // --- Sliders ---
            _buildVoltageSlider(),
            const SizedBox(height: 12),
            _buildLoadSlider(),
            const SizedBox(height: 16),
            // --- Readouts ---
            _buildReadouts(),
          ],
        ),
      ),
    );
  }

  Widget _buildMotorVisual() {
    return Card(
      color: const Color(0xFF0d151c),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: th.WorkshopColors.brassDark, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'DC Motor',
              style: TextStyle(
                color: th.WorkshopColors.brassLight,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 16),
            // Animated rotor
            AnimatedBuilder(
              animation: _rotorController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotorController.value * 2 * math.pi,
                  child: child,
                );
              },
              child: CustomPaint(
                size: const Size(120, 120),
                painter: _RotorPainter(),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${_speedRpm.toStringAsFixed(0)} RPM',
              style: const TextStyle(
                color: Color(0xFF7dd3fc),
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStateIndicator() {
    return Card(
      color: const Color(0xFF0d151c),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: _stateColor().withOpacity(0.4), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(_stateIcon(), color: _stateColor(), size: 24),
            const SizedBox(width: 12),
            Text(
              'Status: $_motorState',
              style: TextStyle(
                color: _stateColor(),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoltageSlider() {
    return _buildSliderCard(
      title: 'Supply Voltage',
      value: _voltage,
      min: 0,
      max: 48,
      unit: 'V',
      divisions: 48,
      onChanged: (v) {
        setState(() => _voltage = v);
        _recalculate();
      },
    );
  }

  Widget _buildLoadSlider() {
    return _buildSliderCard(
      title: 'Mechanical Load',
      value: _loadPercent,
      min: 0,
      max: 100,
      unit: '%',
      divisions: 100,
      onChanged: (v) {
        setState(() => _loadPercent = v);
        _recalculate();
      },
    );
  }

  Widget _buildSliderCard({
    required String title,
    required double value,
    required double min,
    required double max,
    required String unit,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Card(
      color: const Color(0xFF0d151c),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: th.WorkshopColors.ironDark, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${value.toStringAsFixed(1)} $unit',
                  style: const TextStyle(
                    color: Color(0xFF7dd3fc),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: th.WorkshopColors.brass,
                inactiveTrackColor: th.WorkshopColors.ironDark,
                thumbColor: th.WorkshopColors.brassLight,
                overlayColor: th.WorkshopColors.brass.withOpacity(0.2),
                trackHeight: 4,
              ),
              child: Slider(
                value: value,
                min: min,
                max: max,
                divisions: divisions,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadouts() {
    return Card(
      color: const Color(0xFF0d151c),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: th.WorkshopColors.ironDark, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Measurements',
              style: TextStyle(
                color: th.WorkshopColors.brassLight,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            _readoutRow('Speed', '${_speedRpm.toStringAsFixed(0)}', 'rpm'),
            _readoutRow('Armature Current', '${_armatureCurrent.toStringAsFixed(2)}', 'A'),
            _readoutRow('Torque', '${_torque.toStringAsFixed(3)}', 'N·m'),
            _readoutRow('Electrical Power', '${_electricalPower.toStringAsFixed(1)}', 'W'),
            _readoutRow('Mechanical Power', '${_mechanicalPower.toStringAsFixed(1)}', 'W'),
            _readoutRow('Efficiency', '${_efficiency.toStringAsFixed(1)}', '%'),
          ],
        ),
      ),
    );
  }

  Widget _readoutRow(String label, String value, String unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 14),
          ),
          Text(
            '$value $unit',
            style: const TextStyle(
              color: Color(0xFF7dd3fc),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for the motor rotor (a simple 4-pole rotor).
class _RotorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Outer ring
    final ringPaint = Paint()
      ..color = th.WorkshopColors.ironDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius - 2, ringPaint);

    // Rotor body
    final bodyPaint = Paint()
      ..color = th.WorkshopColors.brassDark
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius - 6, bodyPaint);

    // 4 poles
    final polePaint = Paint()
      ..color = th.WorkshopColors.brass
      ..style = PaintingStyle.fill;
    for (int i = 0; i < 4; i++) {
      final angle = i * math.pi / 2;
      final poleCenter = Offset(
        center.dx + (radius - 16) * math.cos(angle),
        center.dy + (radius - 16) * math.sin(angle),
      );
      canvas.drawCircle(poleCenter, 8, polePaint);
    }

    // Center shaft
    final shaftPaint = Paint()
      ..color = th.WorkshopColors.benchLight
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 6, shaftPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
