import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fireguard_app/core/constants/app_colors.dart';
import 'package:fireguard_app/features/quiz/bloc/quiz_bloc.dart';
import 'package:fireguard_app/features/quiz/bloc/quiz_event.dart';
import 'package:fireguard_app/features/quiz/bloc/quiz_state.dart';
import 'package:fireguard_app/features/quiz/widgets/nfpa_explanation_dialog.dart';

class BookmarkedQuestionsPage extends StatelessWidget {
  const BookmarkedQuestionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Bookmarked Questions'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.industrialOrange),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<QuizBloc, QuizState>(
        builder: (context, state) {
          final bookmarked = state.questions.where((q) => q.isBookmarked).toList();

          if (bookmarked.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.industrialOrange.withValues(alpha: 0.5)),
                      ),
                      child: const Icon(Icons.bookmark_border, size: 48, color: AppColors.industrialOrange),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No Bookmarked Questions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurfaceText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Tap the bookmark icon during safety drills to save NFPA standard questions for offline study.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.onSurfaceVariantText,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: bookmarked.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final q = bookmarked[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.surfaceContainerHighest),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.industrialOrange.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'LEVEL ${q.levelId} DRILL',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.industrialOrange,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.bookmark, color: AppColors.industrialOrange, size: 20),
                          onPressed: () {
                            context.read<QuizBloc>().add(QuizBookmarkToggled(q.id));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      q.questionText,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurfaceText,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => NfpaExplanationDialog(nfpaReference: q.nfpaCodeReference),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.industrialGold.withValues(alpha: 0.5)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.menu_book, size: 14, color: AppColors.industrialGold),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                q.nfpaCodeReference,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.industrialGold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
