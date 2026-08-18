import 'package:equatable/equatable.dart';

abstract class LeaderboardEvent extends Equatable {
  const LeaderboardEvent();
  @override
  List<Object?> get props => [];
}

class LeaderboardStarted extends LeaderboardEvent {}

class LeaderboardCategoryChanged extends LeaderboardEvent {
  final String category;
  const LeaderboardCategoryChanged(this.category);

  @override
  List<Object?> get props => [category];
}
