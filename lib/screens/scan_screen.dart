import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/scan_bloc.dart';
import '../widgets/viewfinder_widget.dart';
import '../widgets/camera_button.dart';
import '../widgets/hazard_overlay.dart';
import '../widgets/hazard_details_sheet.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with SingleTickerProviderStateMixin {
  late AnimationController _scanningController;
  late Animation<double> _scanningAnimation;
  bool _useMockMode = true;

  @override
  void initState() {
    super.initState();
    _scanningController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scanningAnimation = Tween<double>(begin: 0.1, end: 0.9).animate(
      CurvedAnimation(parent: _scanningController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scanningController.dispose();
    super.dispose();
  }

  void _showHazardBottomSheet(BuildContext context, ScanState state) {
    var hazard = state.selectedHazard;
    if (hazard == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => FractionallySizedBox(
        heightFactor: 0.75,
        child: HazardDetailsSheet(
          hazard: hazard,
          onClose: () => Navigator.pop(sheetContext),
        ),
      ),
    ).whenComplete(() {
      if (mounted) {
        context.read<ScanBloc>().add(ClearSelection());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (_) => ScanBloc(),
      child: BlocConsumer<ScanBloc, ScanState>(
        listenWhen: (prev, curr) => prev.selectedHazard != curr.selectedHazard && curr.selectedHazard != null,
        listener: _showHazardBottomSheet,
        builder: (context, state) {
          var isAnalyzing = state.status == ScanStatus.analyzing;
          var isAnalyzed = state.status == ScanStatus.analyzed;

          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              fit: StackFit.expand,
              children: [
                // 1. Fullscreen Viewfinder
                ViewfinderWidget(
                  isFrozen: isAnalyzing || isAnalyzed,
                  isAnalyzing: isAnalyzing,
                  useMockMode: _useMockMode,
                  onControllerCreated: (_) {},
                ),

                // 2. Holographic Scanning Line Animation
                if (isAnalyzing)
                  AnimatedBuilder(
                    animation: _scanningAnimation,
                    builder: (context, child) {
                      return Positioned(
                        top: _scanningAnimation.value * size.height,
                        left: 0,
                        right: 0,
                        height: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.primary,
                                blurRadius: 16,
                                spreadRadius: 4,
                              ),
                            ],
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.primary.withValues(alpha: 0.1),
                                theme.colorScheme.primary,
                                theme.colorScheme.primary.withValues(alpha: 0.1),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                // 3. Danger Highlight Overlays
                if (isAnalyzed)
                  SafeArea(
                    child: HazardOverlay(
                      hazards: state.hazards,
                      constraintSize: Size(size.width, size.height - kToolbarHeight - 120),
                      onHazardTap: (hazard) => context.read<ScanBloc>().add(SelectHazard(hazard)),
                    ),
                  ),

                // 4. Custom Top Bar Overlay
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
                      ),
                    ),
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 16,
                      bottom: 16,
                      left: 20,
                      right: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'FallGuard AI',
                              style: GoogleFonts.outfit(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isAnalyzing
                                  ? 'Analyzing space...'
                                  : (isAnalyzed ? 'Scan completed' : 'Live Room Viewfinder'),
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                        // Real / Mock Camera toggle
                        _CameraModeToggle(
                          useMockMode: _useMockMode,
                          onChanged: (val) => setState(() => _useMockMode = val),
                        ),
                      ],
                    ),
                  ),
                ),

                // 5. Custom Bottom control Overlay
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black.withValues(alpha: 0.85), Colors.transparent],
                      ),
                    ),
                    padding: const EdgeInsets.only(bottom: 36, top: 40, left: 24, right: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Dynamic Hint Text
                        Text(
                          isAnalyzing
                              ? 'Scanning room for elderly trip hazards...'
                              : (isAnalyzed
                                    ? 'Hazards Identified! Tap highlighted red areas.'
                                    : 'Point at a walkway and press scan button'),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isAnalyzed ? theme.colorScheme.error : Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Reset Button (Only visible after scan complete)
                            Opacity(
                              opacity: isAnalyzed ? 1.0 : 0.0,
                              child: IgnorePointer(
                                ignoring: !isAnalyzed,
                                child: IconButton.filledTonal(
                                  onPressed: () => context.read<ScanBloc>().add(StartScan()),
                                  icon: const Icon(Icons.refresh_rounded),
                                  style: IconButton.styleFrom(
                                    padding: const EdgeInsets.all(16),
                                    backgroundColor: Colors.white.withValues(alpha: 0.15),
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                            // Central Shutter Button
                            CameraButton(
                              onTap: () => context.read<ScanBloc>().add(TriggerCapture()),
                              isLoading: isAnalyzing,
                              isDisabled: isAnalyzed,
                            ),

                            // Visual Spacer matching the Reset button size
                            const SizedBox(width: 48),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CameraModeToggle extends StatelessWidget {
  final bool useMockMode;
  final ValueChanged<bool> onChanged;

  const _CameraModeToggle({
    required this.useMockMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleOption(
            label: 'Mock',
            isSelected: useMockMode,
            onTap: () => onChanged(true),
          ),
          _ToggleOption(
            label: 'Camera',
            isSelected: !useMockMode,
            onTap: () => onChanged(false),
          ),
        ],
      ),
    );
  }
}

class _ToggleOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}
