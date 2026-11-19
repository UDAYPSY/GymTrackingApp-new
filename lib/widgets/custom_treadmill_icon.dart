import 'package:flutter/material.dart';

class CustomTreadmillIcon extends StatelessWidget {
  final double size;
  final Color color;

  const CustomTreadmillIcon({
    Key? key,
    this.size = 110,
    this.color = const Color(0x3D002B2C),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _TreadmillPainter(color: color),
    );
  }
}

class _TreadmillPainter extends CustomPainter {
  final Color color;

  _TreadmillPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.055
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // Treadmill Base
    canvas.drawLine(
      Offset(w * 0.15, h * 0.82),
      Offset(w * 0.85, h * 0.82),
      strokePaint,
    );

    // Treadmill Front Post & Handle
    final postPath = Path()
      ..moveTo(w * 0.80, h * 0.82)
      ..lineTo(w * 0.78, h * 0.52)
      ..lineTo(w * 0.65, h * 0.52);
    canvas.drawPath(postPath, strokePaint);

    // Runner Head
    canvas.drawCircle(Offset(w * 0.48, h * 0.28), w * 0.08, fillPaint);

    // Runner Torso
    canvas.drawLine(
      Offset(w * 0.48, h * 0.36),
      Offset(w * 0.44, h * 0.55),
      strokePaint,
    );

    // Runner Arms
    // Left arm (forward-bent)
    final leftArm = Path()
      ..moveTo(w * 0.47, h * 0.40)
      ..lineTo(w * 0.56, h * 0.43)
      ..lineTo(w * 0.60, h * 0.38);
    canvas.drawPath(leftArm, strokePaint);

    // Right arm (backward-bent)
    final rightArm = Path()
      ..moveTo(w * 0.47, h * 0.40)
      ..lineTo(w * 0.38, h * 0.46)
      ..lineTo(w * 0.35, h * 0.52);
    canvas.drawPath(rightArm, strokePaint);

    // Runner Legs
    // Front leg (bent up/forward)
    final frontLeg = Path()
      ..moveTo(w * 0.44, h * 0.55)
      ..lineTo(w * 0.55, h * 0.64)
      ..lineTo(w * 0.55, h * 0.79);
    canvas.drawPath(frontLeg, strokePaint);

    // Back leg (extended backward)
    final backLeg = Path()
      ..moveTo(w * 0.44, h * 0.55)
      ..lineTo(w * 0.32, h * 0.68)
      ..lineTo(w * 0.22, h * 0.79);
    canvas.drawPath(backLeg, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
