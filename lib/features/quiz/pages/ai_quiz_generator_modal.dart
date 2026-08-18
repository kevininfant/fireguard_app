import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fireguard_app/core/constants/app_colors.dart';
import 'package:fireguard_app/core/widgets/common_button.dart';
import 'package:fireguard_app/core/widgets/custom_text_field.dart';
import 'package:fireguard_app/features/quiz/bloc/quiz_bloc.dart';
import 'package:fireguard_app/features/quiz/bloc/quiz_event.dart';
import 'package:fireguard_app/features/quiz/bloc/quiz_state.dart';

class AiQuizGeneratorModal extends StatefulWidget {
  final int levelId;

  const AiQuizGeneratorModal({super.key, required this.levelId});

  @override
  State<AiQuizGeneratorModal> createState() => _AiQuizGeneratorModalState();
}

class _AiQuizGeneratorModalState extends State<AiQuizGeneratorModal> {
  final _topicController = TextEditingController(
    text: 'NFPA Electrical Panel Clearances and Fire Suppression Protocols',
  );

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizBloc, QuizState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            top: 20,
            left: 20,
            right: 20,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.auto_awesome, color: AppColors.industrialGold, size: 22),
                      SizedBox(width: 8),
                      Text(
                        'Gemini AI Question Generator',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurfaceText,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.onSurfaceVariantText),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Enter safety guidelines, notes, or NFPA topics. Gemini AI will automatically create multiple-choice questions with answer keys.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.onSurfaceVariantText,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _topicController,
                label: 'Safety Topic / NFPA Code Reference',
                hintText: 'e.g. Hazardous chemical spill protocols',
              ),
              const SizedBox(height: 20),
              if (state.statusMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.successLight),
                  ),
                  child: Text(
                    state.statusMessage!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.successLight,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
              ],
              CommonButton(
                text: 'GENERATE QUESTIONS',
                isLoading: state.isAiGenerating,
                icon: Icons.auto_awesome,
                onPressed: () {
                  if (_topicController.text.trim().isNotEmpty) {
                    context.read<QuizBloc>().add(
                          QuizGenerateAiQuestions(
                            topic: _topicController.text.trim(),
                            levelId: widget.levelId,
                          ),
                        );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
