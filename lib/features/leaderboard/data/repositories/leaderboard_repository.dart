import 'package:fireguard_app/features/auth/data/models/user_model.dart';
import 'package:fireguard_app/features/leaderboard/data/models/leaderboard_user_model.dart';

class LeaderboardRepository {
  final List<LeaderboardUserModel> _defaultUsers = const [
    LeaderboardUserModel(
      uid: 'u1',
      displayName: 'Chief Officer Miller',
      designation: 'Lead EHS Director',
      totalPoints: 2850,
      rank: 1,
      avatarUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
    ),
    LeaderboardUserModel(
      uid: 'u2',
      displayName: 'Sarah Jenkins',
      designation: 'Senior Safety Officer',
      totalPoints: 2410,
      rank: 2,
      avatarUrl:
          'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150',
    ),
    LeaderboardUserModel(
      uid: 'u3',
      displayName: 'David Vance',
      designation: 'Industrial Inspector',
      totalPoints: 1980,
      rank: 3,
      avatarUrl:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
    ),
    LeaderboardUserModel(
      uid: 'u4',
      displayName: 'Alex Rivera',
      designation: 'Site Compliance Lead',
      totalPoints: 1750,
      rank: 4,
    ),
    LeaderboardUserModel(
      uid: 'u5',
      displayName: 'Elena Rostova',
      designation: 'EHS Manager',
      totalPoints: 1620,
      rank: 5,
    ),
    LeaderboardUserModel(
      uid: 'u6',
      displayName: 'Marcus Thorne',
      designation: 'Fire Safety Tech',
      totalPoints: 1490,
      rank: 6,
    ),
    LeaderboardUserModel(
      uid: 'u7',
      displayName: 'Carlos Mendez',
      designation: 'Hazmat Specialist',
      totalPoints: 1380,
      rank: 7,
    ),
  ];

  Future<List<LeaderboardUserModel>> getTopUsers({
    String category = 'All-Time',
    User? currentUser,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final users = _defaultUsers
        .map((user) => _scoreForCategory(user, category))
        .toList();

    if (currentUser != null) {
      users.removeWhere(
        (user) =>
            user.uid == currentUser.uid ||
            user.displayName.toLowerCase() ==
                currentUser.displayName.toLowerCase(),
      );
      users.add(_currentUserEntry(currentUser, category));
    }

    users.sort((a, b) => b.totalPoints.compareTo(a.totalPoints));

    return [
      for (var index = 0; index < users.length; index++)
        users[index].copyWith(rank: index + 1),
    ];
  }

  LeaderboardUserModel _currentUserEntry(User user, String category) {
    final basePoints = switch (category) {
      'Weekly' => (user.points * 0.35).round() + (user.streakDays * 45),
      'Industry Rank' =>
        user.points + (user.currentLevel * 180) + (user.badges.length * 90),
      _ => user.points,
    };

    return LeaderboardUserModel(
      uid: user.uid,
      displayName: user.displayName,
      designation: user.role,
      totalPoints: basePoints,
      rank: 0,
      category: category,
    );
  }

  LeaderboardUserModel _scoreForCategory(
    LeaderboardUserModel user,
    String category,
  ) {
    final score = switch (category) {
      'Weekly' => (user.totalPoints * 0.28).round() + (8 - user.rank) * 35,
      'Industry Rank' => user.totalPoints + (8 - user.rank) * 120,
      _ => user.totalPoints,
    };

    return user.copyWith(totalPoints: score, category: category);
  }
}
