import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fireguard_app/features/dashboard/data/models/level_model.dart';

class DashboardRepository {
  static const String _levelsKey = 'fireguard_levels_data';

  static const List<LevelModel> defaultLevels = [
    LevelModel(
      levelId: 1,
      levelNumber: 1,
      title: 'Level 1: Basic Safety',
      subtitle: 'PASS Extinguisher & Hazard Spotting',
      requiredPoints: 0,
      status: 'COMPLETED',
      scorePts: 150,
    ),
    LevelModel(
      levelId: 2,
      levelNumber: 2,
      title: 'Level 2: Gear Check',
      subtitle: 'PPE & Equipment Clearance',
      requiredPoints: 100,
      status: 'COMPLETED',
      scorePts: 100,
    ),
    LevelModel(
      levelId: 3,
      levelNumber: 3,
      title: 'Level 3: NFPA Protocols',
      subtitle: 'Electrical Panel Clearances & Codes',
      requiredPoints: 250,
      status: 'ACTIVE',
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
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_levelsKey);
    if (data != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(data);
        return jsonList.map((e) => LevelModel.fromJson(e)).toList();
      } catch (_) {}
    }
    await saveLevels(defaultLevels);
    return defaultLevels;
  }

  Future<void> saveLevels(List<LevelModel> levels) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(levels.map((e) => e.toJson()).toList());
    await prefs.setString(_levelsKey, data);
  }

  Future<void> updateLevelStatus(int levelId, String newStatus, int scorePts) async {
    final current = await getLevels();
    final updated = current.map((lvl) {
      if (lvl.levelId == levelId) {
        return lvl.copyWith(status: newStatus, scorePts: scorePts);
      }
      if (lvl.levelId == levelId + 1 && lvl.status == 'LOCKED') {
        return lvl.copyWith(status: 'ACTIVE');
      }
      return lvl;
    }).toList();
    await saveLevels(updated);
  }
}
