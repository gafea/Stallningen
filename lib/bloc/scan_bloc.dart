import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class TriggerCapture extends ScanEvent {}

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

    // Simulate analysis delay (1.5 seconds)
    await Future.delayed(const Duration(milliseconds: 1500));

    emit(
      state.copyWith(
        status: ScanStatus.analyzed,
        hazards: Hazard.getMockHazards(),
      ),
    );
  }

  void _onSelectHazard(SelectHazard event, Emitter<ScanState> emit) {
    emit(state.copyWith(selectedHazard: () => event.hazard));
  }

  void _onClearSelection(ClearSelection event, Emitter<ScanState> emit) {
    emit(state.copyWith(selectedHazard: () => null));
  }
}
