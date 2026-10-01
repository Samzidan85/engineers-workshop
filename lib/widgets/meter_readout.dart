import 'package:flutter/material.dart';
import 'package:engineers_workshop/circuit_engine.dart';
import 'package:engineers_workshop/widgets/component_block.dart';

class MeterReadout extends StatefulWidget {
  final Meter meter;
  final SolveResult? lastSolve;
  final List<ComponentBlock> blocks;
  final Function(String, Offset) onTerminalTap;

  const MeterReadout({
    super.key,
    required this.meter,
    required this.lastSolve,
    required this.blocks,
    required this.onTerminalTap,
  });

  @override
  State<MeterReadout> createState() => _MeterReadoutState();
}

class _MeterReadoutState extends State<MeterReadout> {
  String? _measuredComponentId;

  @override
  Widget build(BuildContext context) {
    final pos = widget.meter.position;
    final halfW = 72.0;
    final halfH = 56.0;

    return Positioned(
      left: pos.dx - halfW / 2,
      top: pos.dy - halfH / 2,
      child: GestureDetector(
        onTapDown: (details) {
          final tid = _hitTestTerminal(details.localPosition, halfW, halfH);
          if (tid != null) {
            widget.onTerminalTap(tid, details.localPosition);
          }
        },
        child: Container(
          width: halfW,
          height: halfH,
          decoration: BoxDecoration(
            color: const Color(0xFF2D3748),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFF4A5568), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(1, 2),
              ),
            ],
          ),
          child: widget.meter.type == MeterType.voltmeter
              ? _buildVoltmeter(halfW, halfH)
              : _buildAmmeter(halfW, halfH),
        ),
      ),
    );
  }

  Widget _buildVoltmeter(double w, double h) {
    final voltage = _readVoltage();
    final displayValue = voltage.abs() < 0.001 ? '0.00' : voltage.abs().toStringAsFixed(2);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: w - 12,
          height: 22,
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF1A202C),
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: const Color(0xFF1A202C), width: 1),
          ),
          child: Center(
            child: Text(
              displayValue,
              style: const TextStyle(
                color: Color(0xFF48BB78),
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _meterTerminal('+', const Color(0xFFE53E3E), Alignment.centerLeft, w, h),
            const Spacer(),
            Container(
              width: 20,
              height: 14,
              decoration: BoxDecoration(
                color: const Color(0xFF4A5568),
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: const Color(0xFF1A202C), width: 1),
              ),
              child: const Center(
                child: Text('V', style: TextStyle(color: Color(0xFFA0AEC0), fontSize: 8, fontWeight: FontWeight.bold)),
              ),
            ),
            const Spacer(),
            _meterTerminal('−', const Color(0xFF1A202C), Alignment.centerRight, w, h),
          ],
        ),
        const SizedBox(height: 4),
        const Center(
          child: Text(
            'DC V',
            style: TextStyle(
              color: Color(0xFFA0AEC0),
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmmeter(double w, double h) {
    final current = _readCurrent();
    final displayValue = current.abs() < 0.001 ? '0.00' : current.abs().toStringAsFixed(2);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: w - 12,
          height: 22,
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF1A202C),
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: const Color(0xFF1A202C), width: 1),
          ),
          child: Center(
            child: Text(
              displayValue,
              style: TextStyle(
                color: current.abs() > 5.0
                    ? const Color(0xFFFC8181)
                    : const Color(0xFF48BB78),
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _meterTerminal('+', const Color(0xFFE53E3E), Alignment.centerLeft, w, h),
            const Spacer(),
            Container(
              width: 20,
              height: 14,
              decoration: BoxDecoration(
                color: const Color(0xFF4A5568),
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: const Color(0xFF1A202C), width: 1),
              ),
              child: const Center(
                child: Text('A', style: TextStyle(color: Color(0xFFA0AEC0), fontSize: 8, fontWeight: FontWeight.bold)),
              ),
            ),
            const Spacer(),
            _meterTerminal('−', const Color(0xFF1A202C), Alignment.centerRight, w, h),
          ],
        ),
        const SizedBox(height: 4),
        const Center(
          child: Text(
            'DC A',
            style: TextStyle(
              color: Color(0xFFA0AEC0),
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _meterTerminal(String label, Color color, Alignment align, double w, double h) {
    return Positioned(
      left: align.x < 0 ? 4 : w - 16,
      top: 0,
      bottom: 0,
      child: Container(
        width: 12,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 7,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  double _readVoltage() {
    if (widget.lastSolve == null || !widget.lastSolve!.success) return 0.0;
    return widget.lastSolve!.nodeVoltage(widget.meter.nodeP.id) -
        widget.lastSolve!.nodeVoltage(widget.meter.nodeN.id);
  }

  double _readCurrent() {
    if (_measuredComponentId == null) return 0.0;
    if (widget.lastSolve == null || !widget.lastSolve!.success) return 0.0;
    return widget.lastSolve!.componentCurrent(_measuredComponentId!);
  }

  String? _hitTestTerminal(Offset pos, double w, double h) {
    if (pos.dx < 16) return '+';
    if (pos.dx > w - 16) return '−';
    return null;
  }
}

class Meter {
  final String id;
  final MeterType type;
  final Offset position;
  final Node nodeP;
  final Node nodeN;
  final String label;

  Meter({
    required this.id,
    required this.type,
    required this.position,
    required this.nodeP,
    required this.nodeN,
    required this.label,
  });

  String terminalIdP() => '${id}_p';
  String terminalIdN() => '${id}_n';

  bool hasTerminal(String id) => id == terminalIdP() || id == terminalIdN();

  String? hitTestTerminal(Offset pos) {
    final halfW = 72.0;
    if (pos.dx < 16) return terminalIdP();
    if (pos.dx > halfW - 16) return terminalIdN();
    return null;
  }
}

enum MeterType { voltmeter, ammeter }
