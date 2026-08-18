import 'package:equatable/equatable.dart';
import 'package:fireguard_app/features/dashboard/data/models/level_model.dart';

enum DashboardStatus { initial, loading, success, failure }

class DashboardState extends Equatable {
  final DashboardStatus status;
  final List<LevelModel> levels;
  final String? errorMessage;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.levels = const [],
    this.errorMessage,
  });

  DashboardState copyWith({
    DashboardStatus? status,
    List<LevelModel>? levels,
    String? errorMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      levels: levels ?? this.levels,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, levels, errorMessage];
}
