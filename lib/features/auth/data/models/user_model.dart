import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String uid;
  final String email;
  final String displayName;
  final String role;
  final int points;
  final int currentLevel;
  final int streakDays;
  final List<String> badges;
  final List<String> unlockedCoupons;
  final List<String> bookmarkedQuestions;

  const User({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.role,
    this.points = 1250,
    this.currentLevel = 3,
    this.streakDays = 3,
    this.badges = const ['Fire Inspector Level 1'],
    this.unlockedCoupons = const ['GRAINGER-20'],
    this.bookmarkedQuestions = const [],
  });

  User copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? role,
    int? points,
    int? currentLevel,
    int? streakDays,
    List<String>? badges,
    List<String>? unlockedCoupons,
    List<String>? bookmarkedQuestions,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      points: points ?? this.points,
      currentLevel: currentLevel ?? this.currentLevel,
      streakDays: streakDays ?? this.streakDays,
      badges: badges ?? this.badges,
      unlockedCoupons: unlockedCoupons ?? this.unlockedCoupons,
      bookmarkedQuestions: bookmarkedQuestions ?? this.bookmarkedQuestions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'role': role,
      'points': points,
      'currentLevel': currentLevel,
      'streakDays': streakDays,
      'badges': badges,
      'unlockedCoupons': unlockedCoupons,
      'bookmarkedQuestions': bookmarkedQuestions,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'] ?? 'usr_001',
      email: json['email'] ?? 'inspector@fireguard.org',
      displayName: json['displayName'] ?? 'Lead Inspector',
      role: json['role'] ?? 'Safety Inspector',
      points: json['points'] is int ? json['points'] : 1250,
      currentLevel: json['currentLevel'] is int ? json['currentLevel'] : 3,
      streakDays: json['streakDays'] is int ? json['streakDays'] : 3,
      badges: (json['badges'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? ['Fire Inspector Level 1'],
      unlockedCoupons: (json['unlockedCoupons'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? ['GRAINGER-20'],
      bookmarkedQuestions: (json['bookmarkedQuestions'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  @override
  List<Object?> get props => [
        uid,
        email,
        displayName,
        role,
        points,
        currentLevel,
        streakDays,
        badges,
        unlockedCoupons,
        bookmarkedQuestions,
      ];
}
