import 'package:equatable/equatable.dart';

class LevelModel extends Equatable {
  final int levelId;
  final int levelNumber;
  final String title;
  final String subtitle;
  final int requiredPoints;
  final String status; // 'COMPLETED', 'ACTIVE', 'LOCKED'
  final int scorePts;

  const LevelModel({
    required this.levelId,
    required this.levelNumber,
    required this.title,
    required this.subtitle,
    required this.requiredPoints,
    required this.status,
    this.scorePts = 0,
  });

  bool get isCompleted => status.toUpperCase() == 'COMPLETED';
  bool get isActive => status.toUpperCase() == 'ACTIVE';
  bool get isLocked => status.toUpperCase() == 'LOCKED';

  LevelModel copyWith({
    int? levelId,
    int? levelNumber,
    String? title,
    String? subtitle,
    int? requiredPoints,
    String? status,
    int? scorePts,
  }) {
    return LevelModel(
      levelId: levelId ?? this.levelId,
      levelNumber: levelNumber ?? this.levelNumber,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      requiredPoints: requiredPoints ?? this.requiredPoints,
      status: status ?? this.status,
      scorePts: scorePts ?? this.scorePts,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'levelId': levelId,
      'levelNumber': levelNumber,
      'title': title,
      'subtitle': subtitle,
      'requiredPoints': requiredPoints,
      'status': status,
      'scorePts': scorePts,
    };
  }

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      levelId: json['levelId'] ?? json['level_number'] ?? 1,
      levelNumber: json['levelNumber'] ?? json['level_number'] ?? 1,
      title: json['title'] ?? 'Level 1: Basic Safety',
      subtitle: json['subtitle'] ?? 'PASS Extinguisher & Hazard Spotting',
      requiredPoints: json['requiredPoints'] ?? json['required_points'] ?? 0,
      status: json['status'] ?? 'ACTIVE',
      scorePts: json['scorePts'] ?? json['score_pts'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [levelId, levelNumber, title, subtitle, requiredPoints, status, scorePts];
}
