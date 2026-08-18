import 'package:flutter/material.dart';
import 'package:fireguard_app/core/constants/app_colors.dart';

class QuizTimerWidget extends StatelessWidget {
  final int timeRemaining;

  const QuizTimerWidget({super.key, required this.timeRemaining});

  @override
  Widget build(BuildContext context) {
    final isUrgent = timeRemaining <= 10;
    final timerColor = isUrgent ? AppColors.safetyRed : AppColors.industrialGold;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUrgent ? AppColors.safetyRed : AppColors.surfaceContainerHighest,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer, color: timerColor, size: 16),
          const SizedBox(width: 6),
          Text(
            '00:${timeRemaining.toString().padLeft(2, '0')}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: timerColor,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
