import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fireguard_app/features/quiz/bloc/quiz_event.dart';
import 'package:fireguard_app/features/quiz/bloc/quiz_state.dart';
import 'package:fireguard_app/features/quiz/data/repositories/quiz_repository.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final QuizRepository _quizRepository;
  Timer? _timer;

  QuizBloc({QuizRepository? quizRepository})
      : _quizRepository = quizRepository ?? QuizRepository(),
        super(const QuizState()) {
    on<QuizStarted>(_onStarted);
    on<QuizAnswerSelected>(_onAnswerSelected);
    on<QuizNextQuestionRequested>(_onNextQuestion);
    on<QuizTimerTick>(_onTimerTick);
    on<QuizBookmarkToggled>(_onBookmarkToggled);
    on<QuizGenerateAiQuestions>(_onGenerateAiQuestions);
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeRemaining > 1) {
        add(QuizTimerTick(state.timeRemaining - 1));
      } else {
        _timer?.cancel();
        add(QuizNextQuestionRequested());
      }
    });
  }

  Future<void> _onStarted(
    QuizStarted event,
    Emitter<QuizState> emit,
  ) async {
    emit(state.copyWith(status: QuizStatus.loading));
    try {
      final questions = await _quizRepository.getQuestionsForLevel(event.levelId);
      emit(state.copyWith(
        status: QuizStatus.inProgress,
        levelId: event.levelId,
        questions: questions,
        currentQuestionIndex: 0,
        selectedAnswers: {},
        timeRemaining: 30,
      ));
      _startTimer();
    } catch (e) {
      emit(state.copyWith(
        status: QuizStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onAnswerSelected(
    QuizAnswerSelected event,
    Emitter<QuizState> emit,
  ) {
    final updated = Map<int, int>.from(state.selectedAnswers);
    updated[event.questionIndex] = event.optionIndex;
    emit(state.copyWith(selectedAnswers: updated));
  }

  void _onTimerTick(
    QuizTimerTick event,
    Emitter<QuizState> emit,
  ) {
    emit(state.copyWith(timeRemaining: event.timeRemaining));
  }

  void _onNextQuestion(
    QuizNextQuestionRequested event,
    Emitter<QuizState> emit,
  ) {
    if (state.currentQuestionIndex < state.questions.length - 1) {
      emit(state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex + 1,
        timeRemaining: 30,
      ));
      _startTimer();
    } else {
      _timer?.cancel();
      // Calculate scores
      int correctCount = 0;
      for (int i = 0; i < state.questions.length; i++) {
        final selected = state.selectedAnswers[i];
        if (selected != null && selected == state.questions[i].correctOptionIndex) {
          correctCount++;
        }
      }
      final accuracy = state.questions.isNotEmpty
          ? ((correctCount / state.questions.length) * 100).round()
          : 100;
      final pointsEarned = correctCount * 50;

      emit(state.copyWith(
        status: QuizStatus.completed,
        scorePoints: pointsEarned,
        accuracyPercent: accuracy,
      ));
    }
  }

  Future<void> _onBookmarkToggled(
    QuizBookmarkToggled event,
    Emitter<QuizState> emit,
  ) async {
    await _quizRepository.toggleBookmark(event.questionId);
    final updatedQuestions = state.questions.map((q) {
      if (q.id == event.questionId) {
        return q.copyWith(isBookmarked: !q.isBookmarked);
      }
      return q;
    }).toList();
    emit(state.copyWith(questions: updatedQuestions));
  }

  Future<void> _onGenerateAiQuestions(
    QuizGenerateAiQuestions event,
    Emitter<QuizState> emit,
  ) async {
    emit(state.copyWith(isAiGenerating: true, statusMessage: 'Generating AI Questions...'));
    try {
      final generated = await _quizRepository.generateAndAddAiQuestions(
        event.topic,
        event.levelId,
      );
      emit(state.copyWith(
        isAiGenerating: false,
        statusMessage: '✨ Successfully added ${generated.length} AI questions!',
      ));
    } catch (e) {
      emit(state.copyWith(
        isAiGenerating: false,
        errorMessage: 'Error generating AI questions: ${e.toString()}',
      ));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
