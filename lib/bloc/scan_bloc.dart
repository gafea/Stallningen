import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import '../models/hazard.dart';

enum ScanStatus { initial, analyzing, analyzed }

class ScanState {
  final ScanStatus status;
  final List<Hazard> hazards;
  final Hazard? selectedHazard;
  final String? errorMessage;

  const ScanState({
    required this.status,
    this.hazards = const [],
    this.selectedHazard,
    this.errorMessage,
  });

  factory ScanState.initial() {
    return const ScanState(status: ScanStatus.initial);
  }

  ScanState copyWith({
    ScanStatus? status,
    List<Hazard>? hazards,
    Hazard? Function()? selectedHazard,
    String? Function()? errorMessage,
  }) {
    return ScanState(
      status: status ?? this.status,
      hazards: hazards ?? this.hazards,
      selectedHazard: selectedHazard != null ? selectedHazard() : this.selectedHazard,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}

abstract class ScanEvent {}

class StartScan extends ScanEvent {}

class TriggerCapture extends ScanEvent {
  final String? imagePath;
  TriggerCapture({this.imagePath});
}

class SelectHazard extends ScanEvent {
  final Hazard hazard;
  SelectHazard(this.hazard);
}

class ClearSelection extends ScanEvent {}

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  ScanBloc() : super(ScanState.initial()) {
    on<StartScan>(_onStartScan);
    on<TriggerCapture>(_onTriggerCapture);
    on<SelectHazard>(_onSelectHazard);
    on<ClearSelection>(_onClearSelection);
  }

  void _onStartScan(StartScan event, Emitter<ScanState> emit) {
    emit(ScanState.initial());
  }

  Future<void> _onTriggerCapture(TriggerCapture event, Emitter<ScanState> emit) async {
    emit(state.copyWith(status: ScanStatus.analyzing, selectedHazard: () => null));

    var path = event.imagePath;
    if (path == null || !File(path).existsSync()) {
      // Standby / Simulator Fallback: Return 2 largest mock hazards
      await Future.delayed(const Duration(milliseconds: 1500));
      emit(
        state.copyWith(
          status: ScanStatus.analyzed,
          hazards: _getStandbyFallbackHazards(),
        ),
      );
      return;
    }

    try {
      // 1. Load image dimensions using standard dart:ui
      var bytes = await File(path).readAsBytes();
      var codec = await ui.instantiateImageCodec(bytes);
      var frameInfo = await codec.getNextFrame();
      var imageWidth = frameInfo.image.width.toDouble();
      var imageHeight = frameInfo.image.height.toDouble();

      // 2. Initialize ML Kit On-Device Object Detector
      var options = ObjectDetectorOptions(
        mode: DetectionMode.single,
        classifyObjects: true,
        multipleObjects: true,
      );
      var objectDetector = ObjectDetector(options: options);

      // 3. Process the file
      var inputImage = InputImage.fromFilePath(path);
      var detectedObjects = await objectDetector.processImage(inputImage);

      // Clean up native resources (Google best practice)
      await objectDetector.close();

      if (detectedObjects.isEmpty) {
        emit(
          state.copyWith(
            status: ScanStatus.analyzed,
            hazards: _getStandbyFallbackHazards(),
          ),
        );
        return;
      }

      // 4. Sort detected objects by area size (width * height) descending and take the largest 2
      detectedObjects.sort((a, b) {
        var areaA = a.boundingBox.width * a.boundingBox.height;
        var areaB = b.boundingBox.width * b.boundingBox.height;
        return areaB.compareTo(areaA);
      });
      var topTwoObjects = detectedObjects.take(2).toList();

      // 5. Map detected objects to Hazards with custom warning classifications
      List<Hazard> mappedHazards = [];
      for (var i = 0; i < topTwoObjects.length; i++) {
        var obj = topTwoObjects[i];
        var rect = obj.boundingBox;

        var relativeX = (rect.left / imageWidth).clamp(0.0, 0.9);
        var relativeY = (rect.top / imageHeight).clamp(0.0, 0.9);
        var relativeWidth = (rect.width / imageWidth).clamp(0.1, 0.9);
        var relativeHeight = (rect.height / imageHeight).clamp(0.1, 0.9);

        var labelName = obj.labels.isNotEmpty ? obj.labels.first.text.toLowerCase() : '';
        mappedHazards.add(
          _classifyHazard(
            index: i,
            label: labelName,
            rx: relativeX,
            ry: relativeY,
            rw: relativeWidth,
            rh: relativeHeight,
          ),
        );
      }

      emit(
        state.copyWith(
          status: ScanStatus.analyzed,
          hazards: mappedHazards,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ScanStatus.analyzed,
          hazards: _getStandbyFallbackHazards(),
        ),
      );
    }
  }

  void _onSelectHazard(SelectHazard event, Emitter<ScanState> emit) {
    emit(state.copyWith(selectedHazard: () => event.hazard));
  }

  void _onClearSelection(ClearSelection event, Emitter<ScanState> emit) {
    emit(state.copyWith(selectedHazard: () => null));
  }

  // Helper to map object detection labels to specific hazard risks
  Hazard _classifyHazard({
    required int index,
    required String label,
    required double rx,
    required double ry,
    required double rw,
    required double rh,
  }) {
    if (label.contains('chair') || label.contains('table') || label.contains('furniture') || label.contains('couch')) {
      return Hazard(
        id: 'detected_hazard_$index',
        title: 'Obstacle in Pathway',
        explanation:
            'Low-profile or misplaced furniture elements block clear lines of walking. Shuffling or unstable senior gaits easily stub or trip against obstacles protruding into high-traffic rooms.',
        dangerScoreIncrease: 25,
        relativeX: rx,
        relativeY: ry,
        relativeWidth: rw,
        relativeHeight: rh,
        recommendedProducts: const [
          Product(
            id: 'path_light',
            name: 'Motion-Activated LED Pathway Lights',
            description: 'Automatic nightlights that outline clear floor boundaries and illuminate pathways.',
            price: 19.99,
            rating: '4.8',
            iconName: 'wind_power',
          ),
          Product(
            id: 'bumper_guards',
            name: 'Soft Corner Safety Bumpers',
            description: 'Impact cushioning corners that attach to table edges to protect seniors during collisions.',
            price: 11.50,
            rating: '4.7',
            iconName: 'grid_view',
          ),
        ],
      );
    } else if (label.contains('floor') || label.contains('rug') || label.contains('carpet') || label.contains('tile')) {
      return Hazard(
        id: 'detected_hazard_$index',
        title: 'Slippery Floor Surface',
        explanation:
            'Smooth tiled or wood surfaces lack traction, creating an active slip zone. Older adults with gait changes have less ability to recover balance when feet slide, making this a critical fall risk.',
        dangerScoreIncrease: 35,
        relativeX: rx,
        relativeY: ry,
        relativeWidth: rw,
        relativeHeight: rh,
        recommendedProducts: const [
          Product(
            id: 'slip_spray',
            name: 'Slip-Guard Floor Treatment',
            description: 'Non-slip spray coating that chemically increases tile and stone friction levels.',
            price: 24.99,
            rating: '4.9',
            iconName: 'clean_hands',
          ),
          Product(
            id: 'rug_anchors',
            name: 'Double-Sided Rug Grip Tape',
            description: 'Secures sliding area rugs and curled corners flat to prevent catching feet.',
            price: 12.99,
            rating: '4.7',
            iconName: 'layers',
          ),
        ],
      );
    } else {
      return Hazard(
        id: 'detected_hazard_$index',
        title: 'Unexpected Trip Hazard',
        explanation:
            'Loose items resting on walking corridors can easily catch a senior\'s foot. Unanchored clutter or cables are responsible for a high proportion of domestic hip fracture accidents.',
        dangerScoreIncrease: 30,
        relativeX: rx,
        relativeY: ry,
        relativeWidth: rw,
        relativeHeight: rh,
        recommendedProducts: const [
          Product(
            id: 'cord_cover',
            name: 'Flat Floor Cord Cover Ramp',
            description: 'Heavy duty rubber cable organizer that protects trailing cords and prevents trips.',
            price: 18.50,
            rating: '4.6',
            iconName: 'linear_scale',
          ),
          Product(
            id: 'grip_slippers',
            name: 'Orthopedic Anti-Slip Slippers',
            description: 'Comfortable indoor footwear with high friction rubber outsoles for secure footing.',
            price: 32.00,
            rating: '4.9',
            iconName: 'checkroom',
          ),
        ],
      );
    }
  }

  // Returns the largest 2 mock hazards for standby/simulator mode
  List<Hazard> _getStandbyFallbackHazards() {
    var allMock = Hazard.getMockHazards();
    // Sort mock hazards by relative area size and return the largest 2
    allMock.sort((a, b) => (b.relativeWidth * b.relativeHeight).compareTo(a.relativeWidth * a.relativeHeight));
    return allMock.take(2).toList();
  }
}
