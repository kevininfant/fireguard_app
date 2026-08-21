import 'package:equatable/equatable.dart';
import 'package:fireguard_app/features/auth/data/models/user_model.dart';

abstract class LeaderboardEvent extends Equatable {
  const LeaderboardEvent();
  @override
  List<Object?> get props => [];
}

class LeaderboardStarted extends LeaderboardEvent {
  final User? currentUser;

  const LeaderboardStarted({this.currentUser});

  @override
  List<Object?> get props => [currentUser];
}

class LeaderboardCategoryChanged extends LeaderboardEvent {
  final String category;
  final User? currentUser;

  const LeaderboardCategoryChanged(this.category, {this.currentUser});

  @override
  List<Object?> get props => [category, currentUser];
}
