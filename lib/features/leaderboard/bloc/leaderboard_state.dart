import 'package:equatable/equatable.dart';
import 'package:fireguard_app/features/leaderboard/data/models/leaderboard_user_model.dart';

enum LeaderboardStatus { initial, loading, success, failure }

class LeaderboardState extends Equatable {
  final LeaderboardStatus status;
  final List<LeaderboardUserModel> users;
  final String selectedCategory;
  final String? errorMessage;

  const LeaderboardState({
    this.status = LeaderboardStatus.initial,
    this.users = const [],
    this.selectedCategory = 'All-Time',
    this.errorMessage,
  });

  LeaderboardState copyWith({
    LeaderboardStatus? status,
    List<LeaderboardUserModel>? users,
    String? selectedCategory,
    String? errorMessage,
  }) {
    return LeaderboardState(
      status: status ?? this.status,
      users: users ?? this.users,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, users, selectedCategory, errorMessage];
}
