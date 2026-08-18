import 'package:fireguard_app/features/leaderboard/data/models/leaderboard_user_model.dart';

class LeaderboardRepository {
  final List<LeaderboardUserModel> _defaultUsers = const [
    LeaderboardUserModel(
      uid: 'u1',
      displayName: 'Chief Officer Miller',
      designation: 'Lead EHS Director',
      totalPoints: 2850,
      rank: 1,
      avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
    ),
    LeaderboardUserModel(
      uid: 'u2',
      displayName: 'Sarah Jenkins',
      designation: 'Senior Safety Officer',
      totalPoints: 2410,
      rank: 2,
      avatarUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150',
    ),
    LeaderboardUserModel(
      uid: 'u3',
      displayName: 'David Vance',
      designation: 'Industrial Inspector',
      totalPoints: 1980,
      rank: 3,
      avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
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

  Future<List<LeaderboardUserModel>> getTopUsers({String category = 'All-Time'}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _defaultUsers;
  }
}
