import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fireguard_app/features/dashboard/data/models/level_model.dart';
import 'package:fireguard_app/features/quiz/data/repositories/quiz_repository.dart';

class DashboardRepository {
  static const String _levelsKey = 'fireguard_levels_data';
  final QuizRepository _quizRepository;

  DashboardRepository({QuizRepository? quizRepository})
    : _quizRepository = quizRepository ?? QuizRepository();

  static const List<LevelModel> defaultLevels = [
    LevelModel(
      levelId: 1,
      levelNumber: 1,
      title: 'Level 1: Basic Safety',
      subtitle: 'PASS Extinguisher & Hazard Spotting',
      requiredPoints: 0,
      status: 'ACTIVE',
      scorePts: 0,
    ),
    LevelModel(
      levelId: 2,
      levelNumber: 2,
      title: 'Level 2: Gear Check',
      subtitle: 'PPE & Equipment Clearance',
      requiredPoints: 100,
      status: 'LOCKED',
      scorePts: 0,
    ),
    LevelModel(
      levelId: 3,
      levelNumber: 3,
      title: 'Level 3: NFPA Protocols',
      subtitle: 'Electrical Panel Clearances & Codes',
      requiredPoints: 250,
      status: 'LOCKED',
      scorePts: 0,
    ),
    LevelModel(
      levelId: 4,
      levelNumber: 4,
      title: 'Level 4: Evacuation Drill',
      subtitle: 'Emergency Route Clearance',
      requiredPoints: 500,
      status: 'LOCKED',
      scorePts: 0,
    ),
    LevelModel(
      levelId: 5,
      levelNumber: 5,
      title: 'Level 5: First Aid & Hazmat',
      subtitle: 'Chemical Containment & Response',
      requiredPoints: 800,
      status: 'LOCKED',
      scorePts: 0,
    ),
  ];

  Future<List<LevelModel>> getLevels() async {
    final questionLevels = await _getQuestionLevelIds();
    final savedLevels = await _getSavedLevels();
    final savedById = {for (final level in savedLevels) level.levelId: level};

    final dynamicLevels = questionLevels.map((levelId) {
      final saved = savedById[levelId];
      final template = _templateForLevel(levelId);
      return template.copyWith(
        status:
            saved?.status ?? _initialStatusForLevel(levelId, questionLevels),
        scorePts: saved?.scorePts ?? 0,
      );
    }).toList();

    final normalized = _ensureActiveLevel(dynamicLevels);
    await saveLevels(normalized);
    return normalized;
  }

  Future<List<LevelModel>> _getSavedLevels() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_levelsKey);
    if (data != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(data);
        return jsonList.map((e) => LevelModel.fromJson(e)).toList();
      } catch (_) {}
    }
    return [];
  }

  Future<void> saveLevels(List<LevelModel> levels) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(levels.map((e) => e.toJson()).toList());
    await prefs.setString(_levelsKey, data);
  }

  Future<void> updateLevelStatus(
    int levelId,
    String newStatus,
    int scorePts,
  ) async {
    final current = await getLevels();
    final currentIndex = current.indexWhere((lvl) => lvl.levelId == levelId);
    final nextLevelId = currentIndex >= 0 && currentIndex < current.length - 1
        ? current[currentIndex + 1].levelId
        : null;

    final updated = current.map((lvl) {
      if (lvl.levelId == levelId) {
        return lvl.copyWith(status: newStatus, scorePts: scorePts);
      }
      if (lvl.levelId == nextLevelId && lvl.status == 'LOCKED') {
        return lvl.copyWith(status: 'ACTIVE');
      }
      return lvl;
    }).toList();
    await saveLevels(updated);
  }

  Future<List<int>> _getQuestionLevelIds() async {
    final questions = await _quizRepository.getAllQuestions();
    final levelIds = questions.map((q) => q.levelId).toSet().toList()..sort();
    if (levelIds.isNotEmpty) return levelIds;
    return defaultLevels.map((level) => level.levelId).toList();
  }

  LevelModel _templateForLevel(int levelId) {
    return defaultLevels.firstWhere(
      (level) => level.levelId == levelId,
      orElse: () => LevelModel(
        levelId: levelId,
        levelNumber: levelId,
        title: 'Level $levelId: Dynamic Safety Drill',
        subtitle: 'Generated workplace safety questions',
        requiredPoints: (levelId - 1) * 250,
        status: 'LOCKED',
      ),
    );
  }

  String _initialStatusForLevel(int levelId, List<int> levelIds) {
    return levelId == levelIds.first ? 'ACTIVE' : 'LOCKED';
  }

  List<LevelModel> _ensureActiveLevel(List<LevelModel> levels) {
    if (levels.isEmpty || levels.any((level) => level.isActive)) {
      return levels;
    }

    final firstLockedIndex = levels.indexWhere((level) => level.isLocked);
    if (firstLockedIndex == -1) return levels;

    return [
      for (int index = 0; index < levels.length; index++)
        if (index == firstLockedIndex)
          levels[index].copyWith(status: 'ACTIVE')
        else
          levels[index],
    ];
  }
}
