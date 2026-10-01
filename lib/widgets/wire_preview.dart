import 'package:flutter/material.dart';
import 'package:engineers_workshop/widgets/component_block.dart' show ComponentBlock;

class WirePreview extends StatelessWidget {
  final String startTerminalId;
  final String endTerminalId;
  final List<ComponentBlock> blocks;
  final Offset? tempEnd;

  const WirePreview({
    super.key,
    required this.startTerminalId,
    required this.endTerminalId,
    required this.blocks,
    this.tempEnd,
  });

  @override
  Widget build(BuildContext context) {
    final startBlock = _findBlock(startTerminalId);
    if (startBlock == null) return const SizedBox.shrink();

    final startPos = _terminalPosition(startBlock, startTerminalId);
    if (startPos == null) return const SizedBox.shrink();

    Offset endPos;
    if (endTerminalId == 'temp' && tempEnd != null) {
      endPos = tempEnd!;
    } else {
      final endBlock = _findBlock(endTerminalId);
      if (endBlock == null) return const SizedBox.shrink();
      final endPosValue = _terminalPosition(endBlock, endTerminalId);
      if (endPosValue == null) return const SizedBox.shrink();
      endPos = endPosValue;
    }

    final path = Path();
    path.moveTo(startPos.dx, startPos.dy);

    final midX = (startPos.dx + endPos.dx) / 2;
    final dy = (endPos.dy - startPos.dy).abs() * 0.1 + 4;
    final midY = (startPos.dy + endPos.dy) / 2 + dy;

    path.quadraticBezierTo(midX, midY, endPos.dx, endPos.dy);

    final constColor = Color(0xFFE2E8F0);
    final drawColor = Color(0xFFCBD5E1);
    final wireColor = endTerminalId == 'temp' ? drawColor : constColor;
    final size = Size(
      (startPos - endPos).distance + 20,
      (startPos - endPos).distance + 20,
    );
    final offX = startPos.dx < endPos.dx ? startPos.dx - 10 : endPos.dx - 10;
    final offY = startPos.dy < endPos.dy ? startPos.dy - 10 : endPos.dy - 10;
    final offset = Offset(offX, offY);

    return CustomPaint(
      size: size,
      painter: _WirePainter(path: path, color: wireColor),
    );
  }

  ComponentBlock? _findBlock(String terminalId) {
    try {
      return blocks.firstWhere((b) => b.hasTerminal(terminalId));
    } catch (_) {
      return null;
    }
  }

  Offset? _terminalPosition(ComponentBlock block, String terminalId) {
    final size = block.blockSize();
    final halfW = size.width / 2;
    if (terminalId == block.terminalIdP()) {
      return Offset(block.position.dx - halfW, block.position.dy);
    } else {
      return Offset(block.position.dx + halfW, block.position.dy);
    }
  }
}

class _WirePainter extends CustomPainter {
  final Path path;
  final Color color;

  _WirePainter({required this.path, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, paint);

    final highlight = Paint()
      ..color = color.withOpacity(0.4)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, highlight);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
