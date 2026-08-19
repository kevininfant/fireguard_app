import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fireguard_app/core/constants/app_colors.dart';
import 'package:fireguard_app/core/widgets/common_button.dart';
import 'package:fireguard_app/core/widgets/loading_view.dart';
import 'package:fireguard_app/features/auth/bloc/auth_bloc.dart';
import 'package:fireguard_app/features/auth/bloc/auth_event.dart';
import 'package:fireguard_app/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:fireguard_app/features/dashboard/bloc/dashboard_event.dart';
import 'package:fireguard_app/features/quiz/bloc/quiz_bloc.dart';
import 'package:fireguard_app/features/quiz/bloc/quiz_event.dart';
import 'package:fireguard_app/features/quiz/bloc/quiz_state.dart';
import 'package:fireguard_app/features/quiz/widgets/quiz_timer_widget.dart';
import 'package:fireguard_app/features/quiz/widgets/option_card.dart';
import 'package:fireguard_app/features/quiz/widgets/nfpa_explanation_dialog.dart';
import 'package:fireguard_app/features/quiz/pages/ai_quiz_generator_modal.dart';
import 'package:fireguard_app/routes/app_routes.dart';

class QuizPage extends StatefulWidget {
  final int levelId;

  const QuizPage({super.key, required this.levelId});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  bool _hasHandledCompletion = false;

  @override
  void initState() {
    super.initState();
    context.read<QuizBloc>().add(QuizStarted(widget.levelId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuizBloc, QuizState>(
      listener: (context, state) async {
        if (state.status == QuizStatus.completed && !_hasHandledCompletion) {
          _hasHandledCompletion = true;
          final isPassed = state.accuracyPercent >= 70;
          if (isPassed) {
            final dashboardBloc = context.read<DashboardBloc>();
            final authBloc = context.read<AuthBloc>();
            dashboardBloc.add(
              DashboardLevelCompleted(
                levelId: state.levelId,
                pointsEarned: state.scorePoints,
              ),
            );

            final user = authBloc.state.user;
            if (user != null) {
              final updatedUser = user.copyWith(
                points: user.points + state.scorePoints,
                currentLevel: state.levelId >= user.currentLevel
                    ? state.levelId + 1
                    : user.currentLevel,
              );
              authBloc.add(AuthUserUpdated(updatedUser));
            }
          }

          if (!context.mounted) return;
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.quizResults,
            arguments: {
              'levelId': state.levelId,
              'pointsEarned': state.scorePoints,
              'accuracyPercent': state.accuracyPercent,
            },
          );
        }
      },
      builder: (context, state) {
        if (state.status == QuizStatus.loading || state.questions.isEmpty) {
          return const Scaffold(
            backgroundColor: AppColors.darkBackground,
            body: LoadingView(message: 'Initializing NFPA Safety Drill...'),
          );
        }

        final question = state.currentQuestion;
        if (question == null) return const SizedBox.shrink();

        final totalQuestions = state.questions.length;
        final currentIndex = state.currentQuestionIndex;
        final selectedOption = state.selectedAnswers[currentIndex];
        final progress = (currentIndex + 1) / totalQuestions;
        final isBookmarked = question.isBookmarked;

        const optionLabels = ['A', 'B', 'C', 'D'];

        return Scaffold(
          backgroundColor: AppColors.darkBackground,
          appBar: AppBar(
            backgroundColor: AppColors.surfaceContainerLow,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.onSurfaceVariantText,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Level ${state.levelId} Drill',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.industrialOrange,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.auto_awesome,
                  color: AppColors.industrialGold,
                ),
                tooltip: 'Generate AI Questions',
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) =>
                        AiQuizGeneratorModal(levelId: state.levelId),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: isBookmarked
                      ? AppColors.industrialOrange
                      : AppColors.onSurfaceVariantText,
                ),
                tooltip: 'Bookmark for study',
                onPressed: () {
                  context.read<QuizBloc>().add(
                    QuizBookmarkToggled(question.id),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isBookmarked
                            ? 'Removed from bookmarks'
                            : 'Bookmarked NFPA question for offline study',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Linear Progress Bar
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.surfaceContainerHighest,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.industrialOrange,
                  ),
                  minHeight: 3,
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Question Header & Timer Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'QUESTION ${currentIndex + 1} OF $totalQuestions',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.0,
                                color: AppColors.onSurfaceVariantText,
                              ),
                            ),
                            QuizTimerWidget(timeRemaining: state.timeRemaining),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Question Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.surfaceContainerHighest,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                question.questionText,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onSurfaceText,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 12),
                              // NFPA Standard Tag Link
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => NfpaExplanationDialog(
                                      nfpaReference: question.nfpaCodeReference,
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceContainerLow,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: AppColors.industrialGold
                                          .withValues(alpha: 0.5),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.verified,
                                        size: 14,
                                        color: AppColors.industrialGold,
                                      ),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        child: Text(
                                          question.nfpaCodeReference,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.industrialGold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.info_outline,
                                        size: 14,
                                        color: AppColors.industrialGold,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Multiple Choice Options List
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: question.options.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, optIdx) {
                            final isSelected = selectedOption == optIdx;
                            return OptionCard(
                              label: optIdx < optionLabels.length
                                  ? optionLabels[optIdx]
                                  : '${optIdx + 1}',
                              text: question.options[optIdx],
                              isSelected: isSelected,
                              onSelect: () {
                                context.read<QuizBloc>().add(
                                  QuizAnswerSelected(
                                    questionIndex: currentIndex,
                                    optionIndex: optIdx,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // Action Next / Submit Button
                        CommonButton(
                          text: currentIndex < totalQuestions - 1
                              ? 'CONFIRM & NEXT QUESTION'
                              : 'SUBMIT ASSESSMENT',
                          icon: Icons.arrow_forward,
                          onPressed: selectedOption != null
                              ? () {
                                  context.read<QuizBloc>().add(
                                    QuizNextQuestionRequested(),
                                  );
                                }
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
