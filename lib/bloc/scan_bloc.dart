import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'package:ultralytics_yolo/yolo.dart';
import '../models/hazard.dart';
import '../models/preset_hazards.dart';

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
  final double? screenWidth;
  final double? screenHeight;
  TriggerCapture({this.imagePath, this.screenWidth, this.screenHeight});
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

  Future<ui.Image?> _createMaskImage(List<List<double>>? mask, ui.Rect normalizedBox) async {
    if (mask == null || mask.isEmpty || mask[0].isEmpty) return null;
    int maskH = mask.length;
    int maskW = mask[0].length;

    int startX = (normalizedBox.left * maskW).floor().clamp(0, maskW - 1);
    int startY = (normalizedBox.top * maskH).floor().clamp(0, maskH - 1);
    int endX = (normalizedBox.right * maskW).ceil().clamp(0, maskW);
    int endY = (normalizedBox.bottom * maskH).ceil().clamp(0, maskH);

    int width = endX - startX;
    int height = endY - startY;

    if (width <= 0 || height <= 0) return null;

    var rgbaBytes = Uint8List(width * height * 4);
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        if (mask[startY + y][startX + x] > 0.5) {
          int index = (y * width + x) * 4;
          rgbaBytes[index] = 255; // R
          rgbaBytes[index + 1] = 0; // G
          rgbaBytes[index + 2] = 0; // B
          rgbaBytes[index + 3] = 120; // A
        }
      }
    }

    var completer = Completer<ui.Image>();
    ui.decodeImageFromPixels(
      rgbaBytes,
      width,
      height,
      ui.PixelFormat.rgba8888,
      completer.complete,
    );
    return completer.future;
  }

  Future<void> _onTriggerCapture(TriggerCapture event, Emitter<ScanState> emit) async {
    emit(state.copyWith(status: ScanStatus.analyzing, selectedHazard: () => null));

    var path = event.imagePath;
    if (path == null || !File(path).existsSync()) {
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
      var bytes = await File(path).readAsBytes();
      var codec = await ui.instantiateImageCodec(bytes);
      var frameInfo = await codec.getNextFrame();
      var imageWidth = frameInfo.image.width.toDouble();
      var imageHeight = frameInfo.image.height.toDouble();

      final yolo = YOLO(
        modelPath: 'yolo26n-seg',
        task: YOLOTask.segment,
      );
      await yolo.loadModel();
      final resultsMap = await yolo.predict(bytes);
      final detectionsList = resultsMap['detections'] as List?;
      final detectedObjects = (detectionsList ?? [])
          .map((d) => YOLOResult.fromMap(d as Map))
          .toList();
      await yolo.dispose();

      if (detectedObjects.isEmpty) {
        emit(
          state.copyWith(
            status: ScanStatus.analyzed,
            hazards: _getStandbyFallbackHazards(),
          ),
        );
        return;
      }

      detectedObjects.sort((a, b) {
        var areaA = a.boundingBox.width * a.boundingBox.height;
        var areaB = b.boundingBox.width * b.boundingBox.height;
        return areaB.compareTo(areaA);
      });
      var topTwoObjects = detectedObjects.take(2).toList();
      var presets = HazardPreset.getPresets();
      var random = Random();

      List<Hazard> mappedHazards = [];
      for (var i = 0; i < topTwoObjects.length; i++) {
        var obj = topTwoObjects[i];

        var startX = obj.boundingBox.left;
        var startY = obj.boundingBox.top;
        var objWidth = obj.boundingBox.width;
        var objHeight = obj.boundingBox.height;

        double rx, ry, rw, rh;
        if (imageWidth > imageHeight) {
          // 1. Rotate 90-degree sensor landscape to portrait coordinates
          var rxImg = (imageHeight - (startY + objHeight)) / imageHeight;
          var ryImg = startX / imageWidth;
          var rwImg = objHeight / imageHeight;
          var rhImg = objWidth / imageWidth;

          // 2. Adjust for Viewfinder scale-and-crop if screen size is provided
          var screenWidth = event.screenWidth;
          var screenHeight = event.screenHeight;
          if (screenWidth != null && screenHeight != null) {
            var portraitRatio = imageHeight / imageWidth;
            var screenRatio = screenWidth / screenHeight;

            if (screenRatio < portraitRatio) {
              var scale = portraitRatio / screenRatio;
              var leftCrop = (1.0 - 1.0 / scale) / 2.0;
              rx = (rxImg - leftCrop) * scale;
              ry = ryImg;
              rw = rwImg * scale;
              rh = rhImg;
            } else {
              var scale = screenRatio / portraitRatio;
              var topCrop = (1.0 - 1.0 / scale) / 2.0;
              rx = rxImg;
              ry = (ryImg - topCrop) * scale;
              rw = rwImg;
              rh = rhImg * scale;
            }
          } else {
            rx = rxImg;
            ry = ryImg;
            rw = rwImg;
            rh = rhImg;
          }
        } else {
          rx = startX / imageWidth;
          ry = startY / imageHeight;
          rw = objWidth / imageWidth;
          rh = objHeight / imageHeight;
        }

        rx = rx.clamp(0.0, 0.95);
        ry = ry.clamp(0.0, 0.95);
        rw = rw.clamp(0.05, 0.95);
        rh = rh.clamp(0.05, 0.95);

        // Find a matching preset based on object label if possible, else random
        var preset = presets.firstWhere(
          (p) => p.category.toLowerCase().contains(obj.className.toLowerCase()) || 
                 obj.className.toLowerCase().contains(p.category.toLowerCase()),
          orElse: () => presets[random.nextInt(presets.length)],
        );

        ui.Image? maskImage;
        if (obj.mask != null) {
          maskImage = await _createMaskImage(obj.mask, obj.normalizedBox);
        }

        mappedHazards.add(
          Hazard(
            id: 'detected_hazard_${i}_${random.nextInt(1000)}',
            title: preset.title,
            category: preset.category,
            explanation: preset.explanation,
            dangerScoreIncrease: preset.dangerScoreIncrease,
            relativeX: rx,
            relativeY: ry,
            relativeWidth: rw,
            relativeHeight: rh,
            recommendedProducts: preset.recommendedProducts,
            maskImage: maskImage,
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

  List<Hazard> _getStandbyFallbackHazards() {
    var presets = HazardPreset.getPresets();
    var random = Random();

    var firstIdx = random.nextInt(presets.length);
    var secondIdx = (firstIdx + 1 + random.nextInt(presets.length - 1)) % presets.length;

    var p1 = presets[firstIdx];
    var p2 = presets[secondIdx];

    return [
      Hazard(
        id: 'mock_hazard_1',
        title: p1.title,
        category: p1.category,
        explanation: p1.explanation,
        dangerScoreIncrease: p1.dangerScoreIncrease,
        relativeX: 0.15,
        relativeY: 0.62,
        relativeWidth: 0.7,
        relativeHeight: 0.22,
        recommendedProducts: p1.recommendedProducts,
      ),
      Hazard(
        id: 'mock_hazard_2',
        title: p2.title,
        category: p2.category,
        explanation: p2.explanation,
        dangerScoreIncrease: p2.dangerScoreIncrease,
        relativeX: 0.52,
        relativeY: 0.38,
        relativeWidth: 0.4,
        relativeHeight: 0.18,
        recommendedProducts: p2.recommendedProducts,
      ),
    ];
  }
}
