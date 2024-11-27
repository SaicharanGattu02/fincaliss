import 'package:flutter/material.dart';

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double width;
  final double dashWidth;
  final double dashSpace;

  DashedBorderPainter({
    required this.color,
    required this.width,
    this.dashWidth = 4.0,
    this.dashSpace = 4.0,
    
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    final Path path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final double dashWidthWithSpace = dashWidth + dashSpace;
    double startX = 0.0;
    
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidthWithSpace;
    }

    startX = 0.0;
    while (startX < size.height) {
      canvas.drawLine(
        Offset(size.width, startX),
        Offset(size.width, startX + dashWidth),
        paint,
      );
      startX += dashWidthWithSpace;
    }

    startX = 0.0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(size.width - startX, size.height),
        Offset(size.width - startX - dashWidth, size.height),
        paint,
      );
      startX += dashWidthWithSpace;
    }

    startX = 0.0;
    while (startX < size.height) {
      canvas.drawLine(
        Offset(0, size.height - startX),
        Offset(0, size.height - startX - dashWidth),
        paint,
      );
      startX += dashWidthWithSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
