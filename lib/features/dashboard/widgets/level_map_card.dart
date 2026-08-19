import 'package:flutter/material.dart';
import 'package:fireguard_app/core/constants/app_colors.dart';
import 'package:fireguard_app/features/dashboard/data/models/level_model.dart';

class LevelMapCard extends StatelessWidget {
  final LevelModel level;
  final VoidCallback onClick;

  const LevelMapCard({super.key, required this.level, required this.onClick});

  @override
  Widget build(BuildContext context) {
    final isCompleted = level.isCompleted;
    final isActive = level.isActive;
    final isLocked = level.isLocked;

    final borderColor = isActive
        ? AppColors.industrialGold
        : (isCompleted
              ? AppColors.industrialOrange
              : AppColors.surfaceContainerHighest);

    final containerColor = isActive || isCompleted
        ? AppColors.surfaceContainer
        : AppColors.surfaceContainerLow;

    return GestureDetector(
      onTap: isLocked
          ? () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Complete the active level to unlock this drill.',
                  ),
                  backgroundColor: AppColors.surfaceContainerHighest,
                ),
              );
            }
          : onClick,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: isActive ? 2.0 : 1.0),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.industrialGold.withValues(alpha: 0.2),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon Ring
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? AppColors.industrialOrange
                    : (isActive
                          ? AppColors.surfaceContainerHigh
                          : AppColors.surfaceContainerLowest),
                border: Border.all(
                  color: isCompleted
                      ? AppColors.industrialOrange
                      : (isActive
                            ? AppColors.industrialGold
                            : AppColors.surfaceContainerHighest),
                  width: 1.5,
                ),
              ),
              child: Icon(
                isCompleted
                    ? Icons.check
                    : (isActive ? Icons.local_fire_department : Icons.lock),
                color: isCompleted
                    ? AppColors.onIndustrialOrange
                    : (isActive
                          ? AppColors.industrialGold
                          : AppColors.textMuted),
                size: 24,
              ),
            ),
            const SizedBox(height: 10),

            // Level Title
            Text(
              'LEVEL ${level.levelNumber}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
                color: isLocked ? AppColors.textMuted : AppColors.onSurfaceText,
              ),
            ),
            const SizedBox(height: 2),

            // Subtitle
            Text(
              level.title.replaceFirst('Level ${level.levelNumber}: ', ''),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                color: isLocked
                    ? AppColors.textMuted
                    : AppColors.onSurfaceVariantText,
              ),
            ),
            const SizedBox(height: 8),

            // Status Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.industrialOrange.withValues(alpha: 0.15)
                    : (isActive
                          ? AppColors.industrialGold.withValues(alpha: 0.15)
                          : AppColors.surfaceContainerHighest),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                level.status,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: isCompleted
                      ? AppColors.industrialOrange
                      : (isActive
                            ? AppColors.industrialGold
                            : AppColors.textMuted),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
