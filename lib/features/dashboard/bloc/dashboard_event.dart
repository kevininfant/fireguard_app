import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
  @override
  List<Object?> get props => [];
}

class DashboardStarted extends DashboardEvent {}

class DashboardRefreshRequested extends DashboardEvent {}

class DashboardSeedFirebaseRequested extends DashboardEvent {}

class DashboardLevelCompleted extends DashboardEvent {
  final int levelId;
  final int pointsEarned;
  const DashboardLevelCompleted({required this.levelId, required this.pointsEarned});

  @override
  List<Object?> get props => [levelId, pointsEarned];
}
