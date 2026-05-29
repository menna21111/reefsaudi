import 'package:flutter/material.dart';

class CardBorderPainter extends CustomPainter {
  final Color color;

  CardBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color, color.withOpacity(0.7)],
      ).createShader(Rect.fromLTWH(size.width - 4, 0, 4, size.height))
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width - 4, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width - 4, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CardBorderPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
