import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewfinderWidget extends StatefulWidget {
  final bool isFrozen;
  final bool isAnalyzing;
  final bool useMockMode;
  final Function(CameraController?) onControllerCreated;

  const ViewfinderWidget({
    super.key,
    required this.isFrozen,
    required this.isAnalyzing,
    required this.useMockMode,
    required this.onControllerCreated,
  });

  @override
  State<ViewfinderWidget> createState() => _ViewfinderWidgetState();
}

class _ViewfinderWidgetState extends State<ViewfinderWidget> {
  CameraController? _controller;
  bool _isInitializing = false;
  String? _initError;

  @override
  void initState() {
    super.initState();
    if (!widget.useMockMode) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    setState(() {
      _isInitializing = true;
      _initError = null;
    });

    try {
      var cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw Exception('No cameras found on this device');
      }

      var controller = CameraController(
        cameras.first,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await controller.initialize();
      if (!mounted) return;

      setState(() {
        _controller = controller;
        _isInitializing = false;
      });
      widget.onControllerCreated(controller);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _initError = e.toString();
        });
      }
    }
  }

  @override
  void didUpdateWidget(ViewfinderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.useMockMode != oldWidget.useMockMode) {
      if (widget.useMockMode) {
        _controller?.dispose();
        _controller = null;
        widget.onControllerCreated(null);
      } else {
        _initializeCamera();
      }
    }

    // Handle freeze/unfreeze camera preview
    if (_controller != null && _controller!.value.isInitialized) {
      if (widget.isFrozen && !oldWidget.isFrozen) {
        _controller!.pausePreview();
      } else if (!widget.isFrozen && oldWidget.isFrozen) {
        _controller!.resumePreview();
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.useMockMode || _initError != null) {
      return _MockRoomView(isAnalyzing: widget.isAnalyzing);
    }

    if (_isInitializing) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: Text('Camera initialization failed'));
    }

    return CameraPreview(_controller!);
  }
}

class _MockRoomView extends StatelessWidget {
  final bool isAnalyzing;

  const _MockRoomView({required this.isAnalyzing});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Wall/Background (Top 55%)
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.colorScheme.surfaceContainerHighest,
                  theme.colorScheme.surface,
                ],
              ),
            ),
          ),
        ),

        // Cozy kitchen cabinets / shelf details
        Positioned(
          top: 80,
          left: 40,
          right: 40,
          height: 120,
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
            ),
            child: Center(
              child: Icon(
                Icons.soup_kitchen_outlined,
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                size: 48,
              ),
            ),
          ),
        ),

        // 2. Floor (Bottom 45%)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * 0.45,
          child: CustomPaint(
            painter: _FloorPainter(
              tileColor: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
              lineColor: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Wet Puddle (Slippery Floor Hazard)
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.15,
                  bottom: 30,
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 90,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.15),
                      borderRadius: const BorderRadius.all(Radius.elliptical(120, 45)),
                      border: Border.all(color: Colors.blue.withValues(alpha: 0.3), width: 1.5),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.water_drop,
                        color: Colors.blue.withValues(alpha: 0.4),
                        size: 20,
                      ),
                    ),
                  ),
                ),

                // Trailing Extension Cord (Trip Hazard)
                Positioned(
                  right: 30,
                  top: 40,
                  width: 130,
                  height: 80,
                  child: CustomPaint(
                    painter: _CablePainter(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                  ),
                ),

                // Curled Rug (Trip Hazard)
                Positioned(
                  left: 20,
                  top: 10,
                  width: 140,
                  height: 95,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.tertiaryContainer,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(30),
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                          border: Border.all(color: theme.colorScheme.tertiary),
                        ),
                        child: Center(
                          child: Text(
                            'WELCOME',
                            style: GoogleFonts.outfit(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onTertiaryContainer.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      ),
                      // Curled border highlight
                      Positioned(
                        right: 0,
                        top: 0,
                        width: 30,
                        height: 30,
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.error.withValues(alpha: 0.1),
                            borderRadius: const BorderRadius.only(topRight: Radius.circular(30)),
                            border: Border(
                              top: BorderSide(color: theme.colorScheme.error, width: 2),
                              right: BorderSide(color: theme.colorScheme.error, width: 2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FloorPainter extends CustomPainter {
  final Color tileColor;
  final Color lineColor;

  _FloorPainter({required this.tileColor, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = tileColor
      ..style = PaintingStyle.fill;

    // Draw floor background
    canvas.drawRect(Offset.zero & size, paint);

    var linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw perspective grid lines for kitchen tiles
    var width = size.width;
    var height = size.height;

    // Horizontal lines
    for (int i = 0; i <= 6; i++) {
      var y = (i / 6) * height;
      canvas.drawLine(Offset(0, y), Offset(width, y), linePaint);
    }

    // Perspective vertical lines converging towards vanishing point
    var vanishingPointX = width / 2;

    for (int i = 0; i <= 8; i++) {
      var xStart = (i / 8) * width;
      // Calculate intersection with bottom
      canvas.drawLine(
        Offset(xStart, 0),
        Offset(vanishingPointX + (xStart - vanishingPointX) * 1.5, height),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CablePainter extends CustomPainter {
  final Color color;

  _CablePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    var path = Path();
    path.moveTo(0, 0);
    // Draw S-curve cord
    path.cubicTo(size.width * 0.2, size.height * 0.8, size.width * 0.8, size.height * 0.2, size.width, size.height);
    canvas.drawPath(path, paint);

    // Draw cable plug outline
    var plugPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromCenter(center: Offset(size.width, size.height), width: 10, height: 10), plugPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
