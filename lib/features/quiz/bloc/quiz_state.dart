import 'package:equatable/equatable.dart';
import 'package:fireguard_app/features/quiz/data/models/quiz_question_model.dart';

enum QuizStatus { initial, loading, inProgress, completed, failure }

class QuizState extends Equatable {
  final QuizStatus status;
  final int levelId;
  final List<QuizQuestionModel> questions;
  final int currentQuestionIndex;
  final Map<int, int> selectedAnswers; // questionIndex -> optionIndex
  final int timeRemaining;
  final int scorePoints;
  final int accuracyPercent;
  final bool isAiGenerating;
  final String? statusMessage;
  final String? errorMessage;

  const QuizState({
    this.status = QuizStatus.initial,
    this.levelId = 1,
    this.questions = const [],
    this.currentQuestionIndex = 0,
    this.selectedAnswers = const {},
    this.timeRemaining = 30,
    this.scorePoints = 0,
    this.accuracyPercent = 0,
    this.isAiGenerating = false,
    this.statusMessage,
    this.errorMessage,
  });

  QuizQuestionModel? get currentQuestion {
    if (questions.isNotEmpty && currentQuestionIndex < questions.length) {
      return questions[currentQuestionIndex];
    }
    return null;
  }

  QuizState copyWith({
    QuizStatus? status,
    int? levelId,
    List<QuizQuestionModel>? questions,
    int? currentQuestionIndex,
    Map<int, int>? selectedAnswers,
    int? timeRemaining,
    int? scorePoints,
    int? accuracyPercent,
    bool? isAiGenerating,
    String? statusMessage,
    String? errorMessage,
  }) {
    return QuizState(
      status: status ?? this.status,
      levelId: levelId ?? this.levelId,
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      scorePoints: scorePoints ?? this.scorePoints,
      accuracyPercent: accuracyPercent ?? this.accuracyPercent,
      isAiGenerating: isAiGenerating ?? this.isAiGenerating,
      statusMessage: statusMessage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        levelId,
        questions,
        currentQuestionIndex,
        selectedAnswers,
        timeRemaining,
        scorePoints,
        accuracyPercent,
        isAiGenerating,
        statusMessage,
        errorMessage,
      ];
}
