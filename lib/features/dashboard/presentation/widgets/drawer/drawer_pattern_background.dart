import 'package:flutter/material.dart';

import '../../../../../core/utils/app_theme_context.dart';

class DrawerPatternBackground extends StatelessWidget {
  const DrawerPatternBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return ColoredBox(
      color: colors.kBgColor,
      child: CustomPaint(
        painter: _DrawerPatternPainter(
          lineColor: colors.kBorderColor.withValues(alpha: 0.35),
        ),
        child: child,
      ),
    );
  }
}

class _DrawerPatternPainter extends CustomPainter {
  const _DrawerPatternPainter({required this.lineColor});

  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    const step = 48.0;
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1;

    for (var x = 0.0; x < size.width; x += step) {
      for (var y = 0.0; y < size.height; y += step) {
        canvas.drawLine(Offset(x, y), Offset(x + step, y + step), paint);
        canvas.drawLine(Offset(x + step, y), Offset(x, y + step), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DrawerPatternPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor;
  }
}
