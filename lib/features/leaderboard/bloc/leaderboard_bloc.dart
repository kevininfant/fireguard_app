import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fireguard_app/features/leaderboard/bloc/leaderboard_event.dart';
import 'package:fireguard_app/features/leaderboard/bloc/leaderboard_state.dart';
import 'package:fireguard_app/features/leaderboard/data/repositories/leaderboard_repository.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  final LeaderboardRepository _leaderboardRepository;

  LeaderboardBloc({LeaderboardRepository? leaderboardRepository})
    : _leaderboardRepository = leaderboardRepository ?? LeaderboardRepository(),
      super(const LeaderboardState()) {
    on<LeaderboardStarted>(_onStarted);
    on<LeaderboardCategoryChanged>(_onCategoryChanged);
  }

  Future<void> _onStarted(
    LeaderboardStarted event,
    Emitter<LeaderboardState> emit,
  ) async {
    emit(state.copyWith(status: LeaderboardStatus.loading));
    try {
      final users = await _leaderboardRepository.getTopUsers(
        category: state.selectedCategory,
        currentUser: event.currentUser,
      );
      emit(state.copyWith(status: LeaderboardStatus.success, users: users));
    } catch (e) {
      emit(
        state.copyWith(
          status: LeaderboardStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onCategoryChanged(
    LeaderboardCategoryChanged event,
    Emitter<LeaderboardState> emit,
  ) async {
    emit(state.copyWith(selectedCategory: event.category));
    try {
      final users = await _leaderboardRepository.getTopUsers(
        category: event.category,
        currentUser: event.currentUser,
      );
      emit(state.copyWith(users: users));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}
