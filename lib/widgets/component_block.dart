import 'package:flutter/material.dart';
import 'package:engineers_workshop/circuit_engine.dart' as c;
import 'package:engineers_workshop/theme.dart' as th;

enum ComponentType { battery, resistor, lamp, wire }

class ComponentBlock extends StatefulWidget {
  final String id;
  final ComponentType type;
  final String label;
  final double value;
  Offset position;
  final c.Node nodeP;
  final c.Node nodeN;
  final c.Component component;

  ComponentBlock({
    super.key,
    required this.id,
    required this.type,
    required this.label,
    required this.value,
    required this.position,
    required this.nodeP,
    required this.nodeN,
    required this.component,
  });

  String terminalIdP() => '${id}_p';
  String terminalIdN() => '${id}_n';

  bool hasTerminal(String id) => id == terminalIdP() || id == terminalIdN();

  c.Terminal? terminalById(String id) {
    if (id == terminalIdP()) return component.p;
    if (id == terminalIdN()) return component.n;
    return null;
  }

  bool hitTest(Offset pos) {
    final size = blockSize();
    final rect = Rect.fromCenter(center: position, width: size.width + 8, height: size.height + 8);
    return rect.contains(pos);
  }

  String? hitTestTerminal(Offset pos) {
    final size = blockSize();
    final rect = Rect.fromCenter(center: position, width: size.width + 8, height: size.height + 8);
    if (!rect.contains(pos)) return null;

    final halfW = size.width / 2;
    final tolerance = 20.0;

    final leftX = position.dx - halfW;
    final pRect = Rect.fromCenter(center: Offset(leftX, position.dy), width: tolerance * 2, height: tolerance * 2);
    if (pRect.contains(pos)) return terminalIdP();

    final rightX = position.dx + halfW;
    final nRect = Rect.fromCenter(center: Offset(rightX, position.dy), width: tolerance * 2, height: tolerance * 2);
    if (nRect.contains(pos)) return terminalIdN();

    return null;
  }

  Size blockSize() {
    switch (type) {
      case ComponentType.battery:
        return const Size(80, 44);
      case ComponentType.resistor:
        return const Size(60, 44);
      case ComponentType.lamp:
        return const Size(64, 64);
      case ComponentType.wire:
        return const Size(20, 20);
    }
  }

  void updateLampState(double current) {
    if (type == ComponentType.lamp && component is c.Lamp) {
      (component as c.Lamp).updateState(current);
    }
  }

  /// Build the widget (called from CircuitCanvas build)
  Widget build({
    required Function(String, Offset) onTerminalTap,
    required bool isDragging,
  }) {
    final isOn = type == ComponentType.lamp && component is c.Lamp && (component as c.Lamp).on;

    return Positioned(
      left: position.dx - blockSize().width / 2,
      top: position.dy - blockSize().height / 2,
      child: Stack(
        children: [
          _buildBody(isOn),
          _buildTerminal(terminalIdP(), Alignment.centerLeft, onTerminalTap),
          _buildTerminal(terminalIdN(), Alignment.centerRight, onTerminalTap),
          if (isOn) _buildGlow(),
        ],
      ),
    );
  }

  Widget _buildBody(bool isOn) {
    switch (type) {
      case ComponentType.battery:
        return _buildBattery();
      case ComponentType.resistor:
        return _buildResistor();
      case ComponentType.lamp:
        return _buildLamp(isOn);
      case ComponentType.wire:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBattery() {
    return Container(
      width: 80,
      height: 44,
      decoration: BoxDecoration(
        color: Color(0xFF2D3748),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Color(0xFFD4A017), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(1, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 4,
            top: 0,
            bottom: 0,
            child: Container(
              width: 8,
              decoration: const BoxDecoration(
                color: Color(0xFFD4A017),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(2), bottomLeft: Radius.circular(2)),
              ),
            ),
          ),
          Positioned(
            right: 4,
            top: 0,
            bottom: 0,
            child: Container(
              width: 8,
              decoration: const BoxDecoration(
                color: Color(0xFFD4A017),
                borderRadius: BorderRadius.only(topRight: Radius.circular(2), bottomRight: Radius.circular(2)),
              ),
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('+', style: TextStyle(color: Color(0xFFE2E8F0), fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFFE2E8F0),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                const Text('−', style: TextStyle(color: Color(0xFFE2E8F0), fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResistor() {
    return Container(
      width: 60,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFF4A5568),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: const Color(0xFF2D3748), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 3,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: CustomPaint(
        painter: _ResistorPainter(color: const Color(0xFFE53E3E)),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFFA0AEC0),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLamp(bool isOn) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: isOn ? const Color(0xFFF6E05E) : const Color(0xFF4A5568),
        shape: BoxShape.circle,
        border: Border.all(
          color: isOn ? const Color(0xFFED8936) : const Color(0xFF718096),
          width: 2,
        ),
        boxShadow: isOn
            ? [
                BoxShadow(
                  color: Colors.yellow.withOpacity(0.5),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(1, 2),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 3,
                  offset: const Offset(1, 1),
                ),
              ],
      ),
      child: CustomPaint(
        painter: _LampFilamentPainter(isLit: isOn),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isOn ? const Color(0xFF744210) : const Color(0xFFA0AEC0),
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTerminal(String terminalId, Alignment alignment, void Function(String, Offset) onTerminalTap) {
    return Positioned(
      left: alignment.x == -1.0 ? -6 : blockSize().width / 2 + 4,
      top: 0,
      bottom: 0,
      child: GestureDetector(
        onTapDown: (details) {
          onTerminalTap(terminalId, details.localPosition);
        },
        child: Container(
          width: 12,
          decoration: BoxDecoration(
            color: Color(0xFF718096),
            shape: BoxShape.circle,
            border: Border.all(color: Color(0xFF4A5568), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Center(
            child: Text(
              terminalId == terminalIdP() ? '+' : '−',
              style: const TextStyle(
                color: Color(0xFFCBD5E1),
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlow() {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: _GlowPainter(),
        ),
      ),
    );
  }
}

class _ResistorPainter extends CustomPainter {
  final Color color;
  _ResistorPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;
    final midY = h / 2;

    final points = <Offset>[];
    final segments = 5;
    final segW = w / (segments * 2);
    for (int i = 0; i <= segments * 2; i++) {
      final x = i * segW;
      final y = midY + ((i % 2 == 0) ? -6 : 6);
      points.add(Offset(x, y));
    }

    canvas.drawLine(Offset(2, midY), points.first, paint);
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
    canvas.drawLine(points.last, Offset(w - 2, midY), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LampFilamentPainter extends CustomPainter {
  final bool isLit;
  _LampFilamentPainter({required this.isLit});

  @override
  void paint(Canvas canvas, Size size) {
    if (!isLit) {
      final paint = Paint()
        ..color = const Color(0xFF2D3748)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(size.width / 2, size.height / 2), 3, paint);
      return;
    }

    final paint = Paint()
      ..color = const Color(0xFF744210)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2 - 8;

    for (int coil = 0; coil < 2; coil++) {
      final offsetY = (coil == 0 ? -r * 0.4 : r * 0.4);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx, cy + offsetY),
          width: r * 1.2,
          height: r * 0.4,
        ),
        paint,
      );
    }

    final contactPaint = Paint()
      ..color = const Color(0xFF744210)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy), 2.5, contactPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _GlowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [const Color(0xFFF6E05E).withOpacity(0.3), Colors.transparent],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
