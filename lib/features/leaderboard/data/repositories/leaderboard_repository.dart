import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:fireguard_app/features/auth/data/models/user_model.dart';
import 'package:fireguard_app/features/leaderboard/data/models/leaderboard_user_model.dart';

class LeaderboardRepository {
  final FirebaseFirestore _firestore;

  LeaderboardRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Fetches rankings purely and dynamically from Cloud Firestore 'users' collection.
  Future<List<LeaderboardUserModel>> getTopUsers({
    String category = 'All-Time',
    User? currentUser,
  }) async {
    final Map<String, LeaderboardUserModel> usersMap = {};

    try {
      final snapshot = await _firestore
          .collection('users')
          .get()
          .timeout(const Duration(seconds: 5));

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final uid = doc.id;
        final name = (data['displayName'] as String?)?.trim().isNotEmpty == true
            ? (data['displayName'] as String)
            : ((data['email'] as String?)?.split('@').first ?? 'Officer');
        final role = (data['role'] as String?) ?? 'Safety Inspector';
        final points = (data['points'] is num)
            ? (data['points'] as num).toInt()
            : 500;
        final streak = (data['streakDays'] is num)
            ? (data['streakDays'] as num).toInt()
            : 1;
        final level = (data['currentLevel'] is num)
            ? (data['currentLevel'] as num).toInt()
            : 1;
        final badgesCount = (data['badges'] as List?)?.length ?? 1;

        final calculatedPoints = switch (category) {
          'Weekly' => (points * 0.35).round() + (streak * 45),
          'Industry Rank' => points + (level * 180) + (badgesCount * 90),
          _ => points,
        };

        usersMap[uid] = LeaderboardUserModel(
          uid: uid,
          displayName: name,
          designation: role,
          totalPoints: calculatedPoints,
          rank: 0,
          category: category,
          avatarUrl: data['avatarUrl'] as String?,
        );
      }
    } catch (e) {
      debugPrint('LeaderboardRepository Firestore fetch error: $e');
    }

    // Ensure the active logged-in officer is present with current scores
    if (currentUser != null) {
      usersMap[currentUser.uid] = _currentUserEntry(currentUser, category);
    }

    final usersList = usersMap.values.toList();
    usersList.sort((a, b) => b.totalPoints.compareTo(a.totalPoints));

    return [
      for (var index = 0; index < usersList.length; index++)
        usersList[index].copyWith(rank: index + 1),
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
      displayName: user.displayName.isNotEmpty
          ? user.displayName
          : (user.email.split('@').first),
      designation: user.role,
      totalPoints: basePoints,
      rank: 0,
      category: category,
    );
  }
}
