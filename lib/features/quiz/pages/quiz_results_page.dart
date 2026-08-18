import 'package:flutter/material.dart';
import 'package:fireguard_app/core/constants/app_colors.dart';
import 'package:fireguard_app/core/widgets/common_button.dart';
import 'package:fireguard_app/features/quiz/widgets/animated_result_badge.dart';
import 'package:fireguard_app/routes/app_routes.dart';

class QuizResultsPage extends StatelessWidget {
  final int levelId;
  final int pointsEarned;
  final int accuracyPercent;

  const QuizResultsPage({
    super.key,
    required this.levelId,
    required this.pointsEarned,
    required this.accuracyPercent,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  const Text(
                    'Assessment Complete',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurfaceText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Module: Core Fire Safety Principles (Level $levelId)',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.onSurfaceVariantText,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Animated Badge
                  AnimatedResultBadge(
                    pointsEarned: pointsEarned,
                    accuracyPercent: accuracyPercent,
                  ),
                  const SizedBox(height: 32),

                  // Score Stat Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.surfaceContainerHighest),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat('ACCURACY', '$accuracyPercent%', AppColors.industrialGold),
                        Container(width: 1, height: 32, color: AppColors.outlineVariantColor),
                        _buildStat('POINTS', '+$pointsEarned', AppColors.industrialOrange),
                        Container(width: 1, height: 32, color: AppColors.outlineVariantColor),
                        _buildStat('STATUS', 'PASSED', AppColors.successLight),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Buttons
                  CommonButton(
                    text: 'ADVANCE TO NEXT LEVEL',
                    icon: Icons.double_arrow,
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.quiz,
                        arguments: levelId + 1,
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  CommonButton(
                    text: 'RETURN TO DASHBOARD MAP',
                    isOutlined: true,
                    icon: Icons.map,
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.dashboard,
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
            color: AppColors.onSurfaceVariantText,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
      ],
    );
  }
}
