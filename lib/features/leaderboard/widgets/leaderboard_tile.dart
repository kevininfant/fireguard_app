import 'package:flutter/material.dart';
import 'package:fireguard_app/core/constants/app_colors.dart';
import 'package:fireguard_app/core/utils/app_helpers.dart';
import 'package:fireguard_app/features/leaderboard/data/models/leaderboard_user_model.dart';

class LeaderboardTile extends StatelessWidget {
  final LeaderboardUserModel user;
  final bool isCurrentUser;

  const LeaderboardTile({
    super.key,
    required this.user,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? AppColors.industrialOrange.withValues(alpha: 0.12)
            : AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isCurrentUser
              ? AppColors.industrialOrange.withValues(alpha: 0.5)
              : AppColors.surfaceContainerHighest,
        ),
      ),
      child: Row(
        children: [
          // Rank Number
          SizedBox(
            width: 28,
            child: Text(
              '#${user.rank}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isCurrentUser ? AppColors.industrialOrange : AppColors.onSurfaceVariantText,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Avatar
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.surfaceContainerHigh,
            backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
            child: user.avatarUrl == null
                ? const Icon(Icons.person, size: 20, color: AppColors.onSurfaceVariantText)
                : null,
          ),
          const SizedBox(width: 12),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isCurrentUser ? AppColors.industrialOrange : AppColors.onSurfaceText,
                  ),
                ),
                Text(
                  user.designation,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),

          // Points Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isCurrentUser
                    ? AppColors.industrialOrange
                    : AppColors.outlineVariantColor,
              ),
            ),
            child: Text(
              AppHelpers.formatPoints(user.totalPoints),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isCurrentUser ? AppColors.industrialOrange : AppColors.industrialGold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
