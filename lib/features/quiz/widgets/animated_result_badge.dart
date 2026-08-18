import 'package:flutter/material.dart';
import 'package:fireguard_app/core/constants/app_colors.dart';

class AnimatedResultBadge extends StatelessWidget {
  final int pointsEarned;
  final int accuracyPercent;

  const AnimatedResultBadge({
    super.key,
    required this.pointsEarned,
    required this.accuracyPercent,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      height: 190,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Ring 1
          Container(
            width: 190,
            height: 190,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.industrialGold.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
          ),

          // Outer Ring 2
          Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.industrialGold.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
          ),

          // Body Circle
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceContainerHigh,
              border: Border.all(color: AppColors.industrialOrange, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.industrialOrange.withValues(alpha: 0.25),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.military_tech,
                  color: AppColors.industrialGold,
                  size: 36,
                ),
                const SizedBox(height: 4),
                Text(
                  '+$pointsEarned',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.industrialOrange,
                  ),
                ),
                const Text(
                  'PTS EARNED',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                    color: AppColors.onSurfaceVariantText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
