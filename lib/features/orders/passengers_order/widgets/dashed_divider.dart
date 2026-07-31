import 'package:flutter/material.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/order_tokens.dart';

/// A horizontal dashed rule, used above the estimated-total row.
class DashedDivider extends StatelessWidget {
  const DashedDivider({
    super.key,
    this.color = OrderTokens.line,
    this.dashWidth = 5,
    this.dashGap = 4,
    this.thickness = 1,
  });

  final Color color;
  final double dashWidth;
  final double dashGap;
  final double thickness;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, thickness),
      painter: _DashedPainter(color, dashWidth, dashGap, thickness),
    );
  }
}

class _DashedPainter extends CustomPainter {
  _DashedPainter(this.color, this.dashWidth, this.dashGap, this.thickness);

  final Color color;
  final double dashWidth;
  final double dashGap;
  final double thickness;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + dashWidth, 0), paint);
      x += dashWidth + dashGap;
    }
  }

  @override
  bool shouldRepaint(_DashedPainter old) =>
      old.color != color ||
      old.dashWidth != dashWidth ||
      old.dashGap != dashGap ||
      old.thickness != thickness;
}
