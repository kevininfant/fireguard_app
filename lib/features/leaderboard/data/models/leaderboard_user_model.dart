import 'package:equatable/equatable.dart';

class LeaderboardUserModel extends Equatable {
  final String uid;
  final String displayName;
  final String designation;
  final int totalPoints;
  final int rank;
  final String? avatarUrl;
  final String category; // 'Weekly', 'All-Time', 'Industry Rank'

  const LeaderboardUserModel({
    required this.uid,
    required this.displayName,
    required this.designation,
    required this.totalPoints,
    required this.rank,
    this.avatarUrl,
    this.category = 'All-Time',
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'displayName': displayName,
      'designation': designation,
      'totalPoints': totalPoints,
      'rank': rank,
      'avatarUrl': avatarUrl,
      'category': category,
    };
  }

  factory LeaderboardUserModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardUserModel(
      uid: json['uid'] ?? 'u1',
      displayName: json['displayName'] ?? json['name'] ?? 'Inspector',
      designation: json['designation'] ?? json['role'] ?? 'Safety Officer',
      totalPoints: json['totalPoints'] ?? json['points'] ?? 1000,
      rank: json['rank'] ?? 1,
      avatarUrl: json['avatarUrl'] ?? json['photoUrl'],
      category: json['category'] ?? 'All-Time',
    );
  }

  @override
  List<Object?> get props => [uid, displayName, designation, totalPoints, rank, avatarUrl, category];
}
