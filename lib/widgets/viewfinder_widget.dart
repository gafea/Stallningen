import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewfinderWidget extends StatefulWidget {
  final bool isFrozen;
  final bool isAnalyzing;
  final Function(CameraController?) onControllerCreated;

  const ViewfinderWidget({
    super.key,
    required this.isFrozen,
    required this.isAnalyzing,
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
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    setState(() {
      _isInitializing = true;
      _initError = null;
    });

    try {
      var cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw Exception('No camera devices detected');
      }

      var controller = CameraController(
        cameras.first,
        ResolutionPreset.high,
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

    // Handle pause/resume of the live camera stream on freeze
    var controller = _controller;
    if (controller != null && controller.value.isInitialized) {
      if (widget.isFrozen && !oldWidget.isFrozen) {
        controller.pausePreview();
      } else if (!widget.isFrozen && oldWidget.isFrozen) {
        controller.resumePreview();
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
    var controller = _controller;

    if (_initError != null) {
      return const _CameraStandbyRadar();
    }

    if (_isInitializing) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (controller == null || !controller.value.isInitialized) {
      return const _CameraStandbyRadar();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        var size = constraints.biggest;
        var deviceRatio = size.width / size.height;

        // Camera sensor dimensions are in landscape, so swap width/height for portrait calculations
        var previewSize = controller.value.previewSize!;
        var previewRatio = previewSize.height / previewSize.width;

        // Scale to fill container while keeping the correct aspect ratio (non-stretched crop)
        var scale = 1.0;
        if (deviceRatio > previewRatio) {
          scale = deviceRatio / previewRatio;
        } else {
          scale = previewRatio / deviceRatio;
        }

        return ClipRect(
          child: Transform.scale(
            scale: scale,
            child: Center(
              child: AspectRatio(
                aspectRatio: previewRatio,
                child: CameraPreview(controller),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CameraStandbyRadar extends StatelessWidget {
  const _CameraStandbyRadar();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      color: Colors.grey[950],
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Technical radar grid background
          Opacity(
            opacity: 0.1,
            child: GridPaper(
              color: theme.colorScheme.primary,
              divisions: 2,
              subdivisions: 4,
              interval: 100,
            ),
          ),

          // Radar pulse ring
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
          ),

          // Inner grid markings
          Icon(
            Icons.center_focus_weak_rounded,
            color: theme.colorScheme.primary.withValues(alpha: 0.4),
            size: 48,
          ),

          Positioned(
            bottom: 160,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Text(
                'CAMERA STANDBY MODE',
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
