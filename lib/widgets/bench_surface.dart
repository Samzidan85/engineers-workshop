import 'package:flutter/material.dart';
import 'package:engineers_workshop/theme.dart';

class BenchSurface extends StatelessWidget {
  const BenchSurface({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            WorkshopColors.woodSurface,
            WorkshopColors.woodSurfaceDark,
            WorkshopColors.woodSurface,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CustomPaint(
        painter: _BenchGrainPainter(),
      ),
    );
  }
}

class _BenchGrainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = WorkshopColors.woodGrain
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Horizontal wood grain lines
    for (double y = 0; y < size.height; y += 3.5) {
      final offset = (y * 0.7) % 4.0;
      canvas.drawLine(
        Offset(-offset, y),
        Offset(size.width + offset, y + (y % 7) * 0.3),
        paint..color = WorkshopColors.woodGrain.withOpacity(0.15 + (y % 5) * 0.03),
      );
    }

    // A few random darker spots (wear marks)
    final spotPaint = Paint()
      ..color = WorkshopColors.woodDark
      ..style = PaintingStyle.fill;

    final spots = [
      Rect.fromLTWH(120, 80, 40, 20),
      Rect.fromLTWH(300, 200, 60, 15),
      Rect.fromLTWH(80, 300, 30, 25),
      Rect.fromLTWH(400, 120, 50, 20),
      Rect.fromLTWH(200, 400, 45, 18),
    ];

    for (final spot in spots) {
      // Only draw if within size (for responsive layouts, approximate)
      if (spot.right < size.width + 50 && spot.bottom < size.height + 50) {
        canvas.drawRect(spot, spotPaint..color = WorkshopColors.woodDark.withOpacity(0.15));
      }
    }

    // Edge vignette
    final vignette = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.transparent,
          Colors.transparent,
          Colors.black.withOpacity(0.3),
        ],
        stops: const [0.0, 0.7, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), vignette);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
