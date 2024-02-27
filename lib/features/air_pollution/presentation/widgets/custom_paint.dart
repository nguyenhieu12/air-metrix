import 'package:flutter/material.dart';

class MyCustomPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Vẽ hình vòm cung
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 10.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0.0, size.height / 2);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height / 2);
    canvas.drawPath(path, paint);

    // Vẽ các vạch chia
    for (var i = 1; i < 5; i++) {
      final x = size.width / 5 * i;
      final paint = Paint()
        ..color = Colors.grey
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;

      canvas.drawLine(Offset(x, 0.0), Offset(x, size.height), paint);
    }

    // Vẽ mũi tên
    paint
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    // final path = Path();

    path.moveTo(size.width / 5 * 2, size.height / 2);
    path.lineTo(size.width / 5 * 2 - 10.0, size.height / 2 - 10.0);
    path.lineTo(size.width / 5 * 2 - 10.0, size.height / 2 + 10.0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
