import 'package:equatable/equatable.dart';

class QuizQuestionModel extends Equatable {
  final String id;
  final int levelId;
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  final String nfpaCodeReference;
  final bool isBookmarked;

  const QuizQuestionModel({
    required this.id,
    required this.levelId,
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    required this.nfpaCodeReference,
    this.isBookmarked = false,
  });

  QuizQuestionModel copyWith({
    String? id,
    int? levelId,
    String? questionText,
    List<String>? options,
    int? correctOptionIndex,
    String? nfpaCodeReference,
    bool? isBookmarked,
  }) {
    return QuizQuestionModel(
      id: id ?? this.id,
      levelId: levelId ?? this.levelId,
      questionText: questionText ?? this.questionText,
      options: options ?? this.options,
      correctOptionIndex: correctOptionIndex ?? this.correctOptionIndex,
      nfpaCodeReference: nfpaCodeReference ?? this.nfpaCodeReference,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'levelId': levelId,
      'questionText': questionText,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
      'nfpaCodeReference': nfpaCodeReference,
      'isBookmarked': isBookmarked,
    };
  }

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    return QuizQuestionModel(
      id: json['id'] ?? 'q_1',
      levelId: json['levelId'] ?? json['level_id'] ?? 1,
      questionText: json['questionText'] ?? json['question_text'] ?? '',
      options: (json['options'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      correctOptionIndex: json['correctOptionIndex'] ?? json['correct_option_index'] ?? 0,
      nfpaCodeReference: json['nfpaCodeReference'] ?? json['nfpa_code_reference'] ?? 'NFPA Code Standard',
      isBookmarked: json['isBookmarked'] ?? false,
    );
  }

  @override
  List<Object?> get props => [
        id,
        levelId,
        questionText,
        options,
        correctOptionIndex,
        nfpaCodeReference,
        isBookmarked,
      ];
}
