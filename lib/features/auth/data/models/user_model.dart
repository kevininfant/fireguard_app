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
    this.points = 500,
    this.currentLevel = 1,
    this.streakDays = 1,
    this.badges = const ['Safety Trainee'],
    this.unlockedCoupons = const [],
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
      uid: json['uid']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      displayName: json['displayName']?.toString() ?? (json['email']?.toString().split('@').first ?? 'Safety Inspector'),
      role: json['role']?.toString() ?? 'Safety Inspector',
      points: (json['points'] is num) ? (json['points'] as num).toInt() : 500,
      currentLevel: (json['currentLevel'] is num) ? (json['currentLevel'] as num).toInt() : 1,
      streakDays: (json['streakDays'] is num) ? (json['streakDays'] as num).toInt() : 1,
      badges: (json['badges'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const ['Safety Trainee'],
      unlockedCoupons: (json['unlockedCoupons'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      bookmarkedQuestions: (json['bookmarkedQuestions'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
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
