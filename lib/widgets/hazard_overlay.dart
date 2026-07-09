import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui' as ui;
import '../models/hazard.dart';

class HazardOverlay extends StatelessWidget {
  final List<Hazard> hazards;
  final Function(Hazard) onHazardTap;
  final Size constraintSize;

  const HazardOverlay({
    super.key,
    required this.hazards,
    required this.onHazardTap,
    required this.constraintSize,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: hazards.expand((hazard) {
        var left = hazard.relativeX * constraintSize.width;
        var top = hazard.relativeY * constraintSize.height;
        var width = hazard.relativeWidth * constraintSize.width;
        var height = hazard.relativeHeight * constraintSize.height;

        return [
          // 1. Pulsing Segmentation Shape Overlay
          Positioned(
            left: left,
            top: top,
            width: width,
            height: height,
            child: _PulsingHazardBox(
              hazard: hazard,
              onTap: () => onHazardTap(hazard),
            ),
          ),

          // 2. Danger Title Label positioned directly below the hazard area
          Positioned(
            left: left - 30,
            top: top + height + 8,
            width: width + 60,
            child: Center(
              child: IgnorePointer(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.redAccent.withValues(alpha: 0.8),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.redAccent,
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          hazard.title,
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ];
      }).toList(),
    );
  }
}

class _PulsingHazardBox extends StatefulWidget {
  final Hazard hazard;
  final VoidCallback onTap;

  const _PulsingHazardBox({
    required this.hazard,
    required this.onTap,
  });

  @override
  State<_PulsingHazardBox> createState() => _PulsingHazardBoxState();
}

class _PulsingHazardBoxState extends State<_PulsingHazardBox> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 0.30, end: 0.70).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _opacityAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: _SegmentationPainter(
              category: widget.hazard.category,
              maskImage: widget.hazard.maskImage,
              fillColor: theme.colorScheme.error.withValues(alpha: _opacityAnimation.value),
              strokeColor: theme.colorScheme.error,
            ),
          );
        },
      ),
    );
  }
}

class _SegmentationPainter extends CustomPainter {
  final String category;
  final ui.Image? maskImage;
  final Color fillColor;
  final Color strokeColor;

  _SegmentationPainter({
    required this.category,
    this.maskImage,
    required this.fillColor,
    required this.strokeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (maskImage != null) {
      var src = Rect.fromLTWH(0, 0, maskImage!.width.toDouble(), maskImage!.height.toDouble());
      var dst = Rect.fromLTWH(0, 0, size.width, size.height);

      var paint = Paint()..colorFilter = ColorFilter.mode(fillColor, BlendMode.srcIn);

      canvas.drawImageRect(maskImage!, src, dst, paint);
      return;
    }

    var fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    var strokePaint = Paint()
      ..color = strokeColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    var path = Path();

    if (category == 'bottle') {
      // Bottle Silhouette Shape
      path.moveTo(size.width * 0.4, size.height * 0.05);
      path.lineTo(size.width * 0.6, size.height * 0.05);
      path.lineTo(size.width * 0.6, size.height * 0.22);
      path.lineTo(size.width * 0.78, size.height * 0.32);
      path.lineTo(size.width * 0.78, size.height * 0.95);
      path.lineTo(size.width * 0.22, size.height * 0.95);
      path.lineTo(size.width * 0.22, size.height * 0.32);
      path.lineTo(size.width * 0.4, size.height * 0.22);
      path.close();

      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, strokePaint);
    } else if (category == 'furniture') {
      // Chair Silhouette Shape
      path.moveTo(size.width * 0.25, size.height * 0.05);
      path.lineTo(size.width * 0.25, size.height * 0.52);
      path.lineTo(size.width * 0.8, size.height * 0.52);
      path.lineTo(size.width * 0.8, size.height * 0.95);
      path.lineTo(size.width * 0.7, size.height * 0.95);
      path.lineTo(size.width * 0.7, size.height * 0.62);
      path.lineTo(size.width * 0.35, size.height * 0.62);
      path.lineTo(size.width * 0.35, size.height * 0.95);
      path.lineTo(size.width * 0.25, size.height * 0.95);
      path.close();

      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, strokePaint);
    } else if (category == 'food') {
      // Bowl Silhouette Shape
      path.moveTo(size.width * 0.1, size.height * 0.4);
      path.lineTo(size.width * 0.9, size.height * 0.4);
      path.cubicTo(
        size.width * 0.85,
        size.height * 0.95,
        size.width * 0.15,
        size.height * 0.95,
        size.width * 0.1,
        size.height * 0.4,
      );
      path.close();

      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, strokePaint);
    } else if (category == 'fashion_good') {
      // Shoe Silhouette Shape
      path.moveTo(size.width * 0.1, size.height * 0.82);
      path.lineTo(size.width * 0.38, size.height * 0.35);
      path.lineTo(size.width * 0.5, size.height * 0.42);
      path.lineTo(size.width * 0.9, size.height * 0.82);
      path.lineTo(size.width * 0.9, size.height * 0.95);
      path.lineTo(size.width * 0.1, size.height * 0.95);
      path.close();

      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, strokePaint);
    } else if (category == 'floor') {
      // Wavy Organic Puddle Shape
      path.moveTo(size.width * 0.1, size.height * 0.5);
      path.cubicTo(
        size.width * 0.15,
        size.height * 0.1,
        size.width * 0.85,
        size.height * 0.15,
        size.width * 0.9,
        size.height * 0.5,
      );
      path.cubicTo(
        size.width * 0.8,
        size.height * 0.9,
        size.width * 0.2,
        size.height * 0.85,
        size.width * 0.1,
        size.height * 0.5,
      );
      path.close();

      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, strokePaint);
    } else if (category == 'cable') {
      // Winding Cord Shape
      path.moveTo(0, size.height * 0.2);
      path.cubicTo(
        size.width * 0.3,
        size.height * 0.9,
        size.width * 0.7,
        size.height * 0.1,
        size.width,
        size.height * 0.8,
      );

      var cordFillPaint = Paint()
        ..color = fillColor.withValues(alpha: (fillColor.a + 0.1).clamp(0.0, 1.0))
        ..strokeWidth = 14.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      var cordStrokePaint = Paint()
        ..color = strokeColor
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawPath(path, cordFillPaint);
      canvas.drawPath(path, cordStrokePaint);
    } else if (category == 'rug') {
      // Curled Rug Triangle Shape
      path.moveTo(0, size.height);
      path.lineTo(size.width * 0.85, size.height * 0.95);
      path.lineTo(size.width, size.height * 0.25);
      path.quadraticBezierTo(
        size.width * 0.45,
        size.height * 0.1,
        0,
        size.height * 0.35,
      );
      path.close();

      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, strokePaint);
    } else {
      // Default Capsule / Oval Silhouette Shape
      path.addOval(Offset.zero & size);

      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
