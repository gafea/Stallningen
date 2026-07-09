import 'package:flutter/material.dart';
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
      children: hazards.map((hazard) {
        var left = hazard.relativeX * constraintSize.width;
        var top = hazard.relativeY * constraintSize.height;
        var width = hazard.relativeWidth * constraintSize.width;
        var height = hazard.relativeHeight * constraintSize.height;

        return Positioned(
          left: left,
          top: top,
          width: width,
          height: height,
          child: _PulsingHazardBox(
            hazard: hazard,
            onTap: () => onHazardTap(hazard),
          ),
        );
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

    _opacityAnimation = Tween<double>(begin: 0.15, end: 0.45).animate(
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
      child: AnimatedBuilder(
        animation: _opacityAnimation,
        builder: (context, child) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Red danger tint background
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withValues(alpha: _opacityAnimation.value),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.error,
                    width: 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.error.withValues(alpha: 0.4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),

              // Pulsing exclamation badge on the top right
              Positioned(
                top: -8,
                right: -8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.priority_high_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
