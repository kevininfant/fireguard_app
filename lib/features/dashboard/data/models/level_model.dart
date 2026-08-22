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

  factory LevelModel.fromJson(Map<String, dynamic> json, [String? docId]) {
    final rawLevelId = json['levelId'] ?? json['level_id'] ?? json['levelNumber'] ?? json['level_number'];
    final parsedLevelId = rawLevelId is int
        ? rawLevelId
        : (int.tryParse(rawLevelId?.toString() ?? '') ?? (int.tryParse(docId ?? '') ?? 1));

    final rawLevelNum = json['levelNumber'] ?? json['level_number'];
    final parsedLevelNum = rawLevelNum is int
        ? rawLevelNum
        : (int.tryParse(rawLevelNum?.toString() ?? '') ?? parsedLevelId);

    final rawPoints = json['pointsRequired'] ?? json['requiredPoints'] ?? json['required_points'] ?? json['points'];
    final parsedPoints = rawPoints is int
        ? rawPoints
        : (int.tryParse(rawPoints?.toString() ?? '') ?? 0);

    final rawScore = json['scorePts'] ?? json['score_pts'];
    final parsedScore = rawScore is int
        ? rawScore
        : (int.tryParse(rawScore?.toString() ?? '') ?? 0);

    final targetStd = json['targetStandard']?.toString();
    final subtitleText = json['subtitle']?.toString() ??
        json['description']?.toString() ??
        (targetStd != null && targetStd.isNotEmpty ? 'Standard: $targetStd' : 'Industrial workplace safety module');

    return LevelModel(
      levelId: parsedLevelId,
      levelNumber: parsedLevelNum,
      title: json['title'] ?? 'Level $parsedLevelNum: Safety Drill',
      subtitle: subtitleText,
      requiredPoints: parsedPoints,
      status: (json['status'] ?? (parsedLevelNum == 1 ? 'ACTIVE' : 'LOCKED')).toString().toUpperCase(),
      scorePts: parsedScore,
    );
  }

  @override
  List<Object?> get props => [levelId, levelNumber, title, subtitle, requiredPoints, status, scorePts];
}
