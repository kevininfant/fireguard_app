import 'package:flutter/material.dart';
import 'package:fireguard_app/core/constants/app_colors.dart';
import 'package:fireguard_app/features/profile/data/models/badge_model.dart';

class BadgeGridCard extends StatelessWidget {
  final BadgeModel badge;

  const BadgeGridCard({super.key, required this.badge});

  IconData _resolveIcon(String name) {
    switch (name) {
      case 'military_tech':
        return Icons.military_tech;
      case 'flash_on':
        return Icons.flash_on;
      case 'warning':
        return Icons.warning_amber;
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'emoji_events':
        return Icons.emoji_events;
      case 'security':
      default:
        return Icons.security;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUnlocked = badge.isUnlocked;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isUnlocked ? AppColors.surfaceContainerLow : AppColors.surfaceContainerLow.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnlocked ? AppColors.industrialGold.withValues(alpha: 0.5) : AppColors.surfaceContainerHighest,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon Circle
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isUnlocked
                  ? AppColors.industrialGold.withValues(alpha: 0.15)
                  : AppColors.surfaceContainerHighest,
              border: Border.all(
                color: isUnlocked ? AppColors.industrialGold : AppColors.outlineVariantColor,
              ),
            ),
            child: Icon(
              _resolveIcon(badge.iconName),
              color: isUnlocked ? AppColors.industrialGold : AppColors.textMuted,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),

          // Title
          Text(
            badge.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isUnlocked ? AppColors.onSurfaceText : AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 4),

          // Condition Tag
          Text(
            badge.triggerCondition,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: isUnlocked ? AppColors.industrialOrange : AppColors.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
