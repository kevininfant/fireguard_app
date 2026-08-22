import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fireguard_app/features/dashboard/bloc/dashboard_event.dart';
import 'package:fireguard_app/features/dashboard/bloc/dashboard_state.dart';
import 'package:fireguard_app/features/dashboard/data/repositories/dashboard_repository.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _dashboardRepository;

  DashboardBloc({DashboardRepository? dashboardRepository})
      : _dashboardRepository = dashboardRepository ?? DashboardRepository(),
        super(const DashboardState()) {
    on<DashboardStarted>(_onStarted);
    on<DashboardRefreshRequested>(_onRefresh);
    on<DashboardSeedFirebaseRequested>(_onSeedFirebase);
    on<DashboardLevelCompleted>(_onLevelCompleted);
  }

  Future<void> _onSeedFirebase(
    DashboardSeedFirebaseRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.loading));
    try {
      final levels = await _dashboardRepository.seedDefaultLevelsToFirebase();
      emit(state.copyWith(
        status: DashboardStatus.success,
        levels: levels,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DashboardStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onStarted(
    DashboardStarted event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.loading));
    try {
      final levels = await _dashboardRepository.getLevels();
      emit(state.copyWith(
        status: DashboardStatus.success,
        levels: levels,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DashboardStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRefresh(
    DashboardRefreshRequested event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      final levels = await _dashboardRepository.getLevels();
      emit(state.copyWith(
        status: DashboardStatus.success,
        levels: levels,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DashboardStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLevelCompleted(
    DashboardLevelCompleted event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      await _dashboardRepository.updateLevelStatus(
        event.levelId,
        'COMPLETED',
        event.pointsEarned,
      );
      final levels = await _dashboardRepository.getLevels();
      emit(state.copyWith(
        status: DashboardStatus.success,
        levels: levels,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DashboardStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
