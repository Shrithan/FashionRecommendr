import 'package:flutter/material.dart';

class YellowCircle extends StatelessWidget {
  final double size;
  final double opacity;

  YellowCircle({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Color(0xFFFFD166).withOpacity(opacity), // Yellow color with opacity
        shape: BoxShape.circle,
      ),
    );
  }
}

// Custom widget for Dotted Shapes
enum ShapeType { triangle, square, rectangle }

class DottedShape extends StatelessWidget {
  final double size;
  final double spacing;
  final ShapeType shape;

  DottedShape({
    required this.size,
    required this.spacing,
    required this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: DottedShapePainter(spacing: spacing, shape: shape),
    );
  }
}

class DottedShapePainter extends CustomPainter {
  final double spacing;
  final ShapeType shape;

  DottedShapePainter({
    required this.spacing,
    required this.shape,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Color(0xFF3A3A6A);
    double dotSize = 5.0;
    if (shape == ShapeType.triangle) {
      // Draw a dotted triangle
      for (double y = 0; y < size.height; y += spacing) {
        for (double x = 0; x <= y; x += spacing) {
          canvas.drawCircle(Offset(x, y), dotSize, paint);
        }
      }
    } else if (shape == ShapeType.square || shape == ShapeType.rectangle) {
      // Draw a dotted square or rectangle
      for (double y = 0; y < size.height; y += spacing) {
        for (double x = 0; x < size.width; x += spacing) {
          canvas.drawCircle(Offset(x, y), dotSize, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Custom painter for straight lines within a specified area and position
class StraightLinesPainter extends CustomPainter {
  final double spacing;
  final Rect bounds;
  final Offset offset;

  StraightLinesPainter({
    required this.spacing,
    required this.bounds,
    required this.offset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color(0xFF3A3A6A) // Blue color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw vertical lines within the bounds
    for (double x = bounds.left + offset.dx; x <= bounds.right + offset.dx; x += spacing) {
      canvas.drawLine(
        Offset(x, bounds.top + offset.dy),
        Offset(x, bounds.bottom + offset.dy),
        paint,
      );
    }

    // Draw horizontal lines within the bounds
    for (double y = bounds.top + offset.dy; y <= bounds.bottom + offset.dy; y += spacing) {
      canvas.drawLine(
        Offset(bounds.left + offset.dx, y),
        Offset(bounds.right + offset.dx, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
