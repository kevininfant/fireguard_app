import 'package:equatable/equatable.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();
  @override
  List<Object?> get props => [];
}

class QuizStarted extends QuizEvent {
  final int levelId;
  const QuizStarted(this.levelId);

  @override
  List<Object?> get props => [levelId];
}

class QuizAnswerSelected extends QuizEvent {
  final int questionIndex;
  final int optionIndex;

  const QuizAnswerSelected({
    required this.questionIndex,
    required this.optionIndex,
  });

  @override
  List<Object?> get props => [questionIndex, optionIndex];
}

class QuizNextQuestionRequested extends QuizEvent {}

class QuizTimerTick extends QuizEvent {
  final int timeRemaining;
  const QuizTimerTick(this.timeRemaining);

  @override
  List<Object?> get props => [timeRemaining];
}

class QuizBookmarkToggled extends QuizEvent {
  final String questionId;
  const QuizBookmarkToggled(this.questionId);

  @override
  List<Object?> get props => [questionId];
}

class QuizGenerateAiQuestions extends QuizEvent {
  final String topic;
  final int levelId;

  const QuizGenerateAiQuestions({
    required this.topic,
    required this.levelId,
  });

  @override
  List<Object?> get props => [topic, levelId];
}
