import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fireguard_app/features/dashboard/data/models/level_model.dart';

class DashboardRepository {
  static const String _levelsKey = 'fireguard_levels_data';
  static const List<String> _collectionCandidates = [
    'safety_levels',
    'levels',
    'safety_certification_path',
    'certification_path',
    'safety_modules',
    'modules',
    'drills',
  ];

  final FirebaseFirestore _firestore;
  String _activeCollection = 'safety_levels';

  DashboardRepository({
    FirebaseFirestore? firestore,
  })  : _firestore = firestore ?? FirebaseFirestore.instance;

  static const List<LevelModel> defaultLevels = [
    LevelModel(
      levelId: 1,
      levelNumber: 1,
      title: 'NFPA 10 Portable Fire Extinguishers Fundamentals',
      subtitle: 'Standard: NFPA 10',
      requiredPoints: 100,
      status: 'ACTIVE',
      scorePts: 0,
    ),
    LevelModel(
      levelId: 2,
      levelNumber: 2,
      title: 'PPE & Breathing Apparatus Inspection Protocol',
      subtitle: 'Standard: NFPA 1852',
      requiredPoints: 200,
      status: 'LOCKED',
      scorePts: 0,
    ),
  ];

  /// Fetches published levels directly from Firebase Firestore.
  /// Deduplicates by levelNumber and filters out drafts/unpublished items.
  Future<List<LevelModel>> getLevels({bool allowLocalFallback = false}) async {
    try {
      for (final collectionName in _collectionCandidates) {
        try {
          final snapshot = await _firestore
              .collection(collectionName)
              .get()
              .timeout(const Duration(seconds: 5));

          if (snapshot.docs.isNotEmpty) {
            _activeCollection = collectionName;

            // 1. Filter out unpublished levels / drafts
            final publishedDocs = snapshot.docs.where((doc) {
              final data = doc.data();

              // Check boolean flags
              if (data['isPublished'] == false ||
                  data['published'] == false ||
                  data['is_published'] == false) {
                return false;
              }

              if (data['isDraft'] == true || data['is_draft'] == true) {
                return false;
              }

              // Check status string
              final status = data['status']?.toString().toUpperCase();
              if (status == 'DRAFT' ||
                  status == 'UNPUBLISHED' ||
                  status == 'ARCHIVED' ||
                  status == 'INACTIVE') {
                return false;
              }

              return true;
            }).toList();

            if (publishedDocs.isEmpty) continue;

            // 2. Parse and Deduplicate by levelNumber
            final Map<int, LevelModel> uniqueByLevel = {};
            for (final doc in publishedDocs) {
              final level = LevelModel.fromJson(doc.data(), doc.id);
              // Store unique level by levelNumber
              if (!uniqueByLevel.containsKey(level.levelNumber)) {
                uniqueByLevel[level.levelNumber] = level;
              }
            }

            final firestoreLevels = uniqueByLevel.values.toList();
            // Sort ascending: Level 1, Level 2, ...
            firestoreLevels.sort((a, b) => a.levelNumber.compareTo(b.levelNumber));

            final normalized = _ensureActiveLevel(firestoreLevels);
            // Overwrite local cache with the exact published Firestore levels
            await saveLevels(normalized);
            return normalized;
          }
        } catch (_) {}
      }
    } catch (e) {
      debugPrint('Firestore getLevels error: $e');
      if (allowLocalFallback) {
        final saved = await _getSavedLevels();
        if (saved.isNotEmpty) return saved;
      }
    }

    return [];
  }

  /// Seeds published safety certification levels directly into Firebase Firestore.
  Future<List<LevelModel>> seedDefaultLevelsToFirebase() async {
    try {
      final batch = _firestore.batch();
      for (final level in defaultLevels) {
        final docRef = _firestore
            .collection(_activeCollection)
            .doc('level_${level.levelId}');

        final firestoreData = {
          'levelNumber': level.levelNumber,
          'title': level.title,
          'targetStandard': level.subtitle.replaceFirst('Standard: ', ''),
          'pointsRequired': level.requiredPoints,
          'status': level.status,
          'scorePts': level.scorePts,
          'isPublished': true,
          'createdAt': DateTime.now().toUtc().toIso8601String(),
        };

        batch.set(docRef, firestoreData, SetOptions(merge: true));
      }
      await batch.commit();
      await saveLevels(defaultLevels);
      return defaultLevels;
    } catch (e) {
      debugPrint('Failed to seed default levels to Firebase: $e');
      await saveLevels(defaultLevels);
      return defaultLevels;
    }
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
    try {
      await _firestore
          .collection(_activeCollection)
          .doc('level_$levelId')
          .set({
        'status': newStatus,
        'scorePts': scorePts,
      }, SetOptions(merge: true));

      if (newStatus == 'COMPLETED') {
        final nextDoc = await _firestore
            .collection(_activeCollection)
            .doc('level_${levelId + 1}')
            .get();
        if (nextDoc.exists) {
          await nextDoc.reference.set({
            'status': 'ACTIVE',
          }, SetOptions(merge: true));
        }
      }
    } catch (e) {
      debugPrint('Firestore update level error: $e');
    }

    final current = await _getSavedLevels();
    if (current.isNotEmpty) {
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
