import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fireguard_app/features/quiz/data/models/quiz_question_model.dart';
import 'package:fireguard_app/features/quiz/data/services/gemini_quiz_service.dart';

class QuizRepository {
  static const String _questionsKey = 'fireguard_quiz_questions_data';
  final GeminiQuizService _geminiService;

  QuizRepository({GeminiQuizService? geminiService})
    : _geminiService = geminiService ?? GeminiQuizService();

  static const List<QuizQuestionModel> defaultQuestions = [
    QuizQuestionModel(
      id: 'q_1_1',
      levelId: 1,
      questionText:
          'What does the PASS acronym stand for when operating a portable fire extinguisher?',
      options: [
        'Pull, Aim, Squeeze, Sweep',
        'Point, Align, Squeeze, Stop',
        'Press, Activate, Spray, Sweep',
        'Pull, Arm, Shield, Secure',
      ],
      correctOptionIndex: 0,
      nfpaCodeReference: 'NFPA 10 Standard for Portable Fire Extinguishers',
    ),
    QuizQuestionModel(
      id: 'q_1_2',
      levelId: 1,
      questionText:
          'Which class of fire extinguisher is specifically designed for energized electrical equipment?',
      options: ['Class A', 'Class B', 'Class C', 'Class K'],
      correctOptionIndex: 2,
      nfpaCodeReference: 'NFPA 10 Section 5.2.3 Class C Hazards',
    ),
    QuizQuestionModel(
      id: 'q_2_1',
      levelId: 2,
      questionText:
          'What is the mandatory inspection frequency for self-contained breathing apparatus (SCBA) cylinders?',
      options: ['Weekly', 'Monthly (30 days)', 'Quarterly', 'Annually'],
      correctOptionIndex: 1,
      nfpaCodeReference: 'NFPA 1852 SCBA Selection, Care and Maintenance',
    ),
    QuizQuestionModel(
      id: 'q_3_1',
      levelId: 3,
      questionText:
          'What is the minimum required clearance space in front of electrical panels operating at 600V or less under NFPA 70?',
      options: [
        '24 inches of clear space',
        '30 inches of clear space',
        '36 inches of clear space',
        '48 inches of clear space',
      ],
      correctOptionIndex: 2,
      nfpaCodeReference:
          'NFPA 70 Section 110.26 Spaces About Electrical Equipment',
    ),
    QuizQuestionModel(
      id: 'q_3_2',
      levelId: 3,
      questionText:
          'According to NFPA 10, how frequently must portable fire extinguishers undergo certified professional inspection?',
      options: [
        'Every 6 months',
        'Annually (12 months)',
        'Every 2 years',
        'Every 5 years',
      ],
      correctOptionIndex: 1,
      nfpaCodeReference: 'NFPA 10 Section 7.3.1 Annual Maintenance',
    ),
    QuizQuestionModel(
      id: 'q_4_1',
      levelId: 4,
      questionText:
          'What is the maximum allowable travel distance to an exit in a non-sprinklered industrial occupancy?',
      options: ['100 feet', '150 feet', '200 feet', '300 feet'],
      correctOptionIndex: 2,
      nfpaCodeReference: 'NFPA 101 Life Safety Code Section 40.2.6',
    ),
    QuizQuestionModel(
      id: 'q_5_1',
      levelId: 5,
      questionText:
          'In the NFPA 704 Diamond hazard identification system, what does the blue diamond represent?',
      options: [
        'Flammability',
        'Health Hazard',
        'Instability / Reactivity',
        'Special Notice',
      ],
      correctOptionIndex: 1,
      nfpaCodeReference: 'NFPA 704 Standard System for Hazard Identification',
    ),
  ];

  Future<List<QuizQuestionModel>> getQuestionsForLevel(int levelId) async {
    final all = await getAllQuestions();
    final filtered = all.where((q) => q.levelId == levelId).toList();
    if (filtered.isNotEmpty) return filtered;

    final generated = _geminiService.generateFallbackQuestions(
      'Level $levelId Standard Drills',
      levelId: levelId,
    );
    await saveQuestions([...all, ...generated]);
    return generated;
  }

  Future<List<QuizQuestionModel>> getAllQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_questionsKey);
    if (data != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(data);
        return jsonList.map((e) => QuizQuestionModel.fromJson(e)).toList();
      } catch (_) {}
    }
    await saveQuestions(defaultQuestions);
    return defaultQuestions;
  }

  Future<void> saveQuestions(List<QuizQuestionModel> questions) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(questions.map((e) => e.toJson()).toList());
    await prefs.setString(_questionsKey, data);
  }

  Future<void> toggleBookmark(String questionId) async {
    final all = await getAllQuestions();
    final updated = all.map((q) {
      if (q.id == questionId) {
        return q.copyWith(isBookmarked: !q.isBookmarked);
      }
      return q;
    }).toList();
    await saveQuestions(updated);
  }

  Future<List<QuizQuestionModel>> generateAndAddAiQuestions(
    String topic,
    int levelId,
  ) async {
    final newQuestions = await _geminiService.generateQuestionsFromTopic(
      topic,
      levelId: levelId,
    );
    final all = await getAllQuestions();
    final updated = [...all, ...newQuestions];
    await saveQuestions(updated);
    return newQuestions;
  }
}
