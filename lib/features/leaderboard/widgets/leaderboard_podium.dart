import 'package:flutter/material.dart';
import 'package:fireguard_app/core/constants/app_colors.dart';
import 'package:fireguard_app/core/utils/app_helpers.dart';
import 'package:fireguard_app/features/leaderboard/data/models/leaderboard_user_model.dart';

class LeaderboardPodium extends StatelessWidget {
  final List<LeaderboardUserModel> topThree;

  const LeaderboardPodium({super.key, required this.topThree});

  @override
  Widget build(BuildContext context) {
    if (topThree.length < 3) return const SizedBox.shrink();

    final first = topThree[0];
    final second = topThree[1];
    final third = topThree[2];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 2nd Place (Silver)
          _buildPodiumSpot(
            user: second,
            rank: 2,
            height: 110,
            rankColor: const Color(0xFFC0C0C0),
          ),
          const SizedBox(width: 12),

          // 1st Place (Gold)
          _buildPodiumSpot(
            user: first,
            rank: 1,
            height: 140,
            rankColor: AppColors.industrialGold,
            isCenter: true,
          ),
          const SizedBox(width: 12),

          // 3rd Place (Bronze)
          _buildPodiumSpot(
            user: third,
            rank: 3,
            height: 95,
            rankColor: const Color(0xFFCD7F32),
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumSpot({
    required LeaderboardUserModel user,
    required int rank,
    required double height,
    required Color rankColor,
    bool isCenter = false,
  }) {
    final avatarSize = isCenter ? 64.0 : 52.0;

    return Expanded(
      child: Column(
        children: [
          // Avatar with Rank Badge
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: rankColor, width: 2),
                ),
                child: ClipOval(
                  child: user.avatarUrl != null
                      ? Image.network(
                          user.avatarUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.person, color: AppColors.textMuted),
                        )
                      : const Icon(Icons.person, color: AppColors.textMuted),
                ),
              ),
              Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: rankColor,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$rank',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Name
          Text(
            user.displayName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurfaceText,
            ),
          ),
          const SizedBox(height: 2),

          // Points
          Text(
            AppHelpers.formatPoints(user.totalPoints),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: rankColor,
            ),
          ),
          const SizedBox(height: 8),

          // Podium Column
          Container(
            height: height,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              border: Border(
                top: BorderSide(color: rankColor, width: 3),
                left: const BorderSide(color: AppColors.surfaceContainerHighest),
                right: const BorderSide(color: AppColors.surfaceContainerHighest),
              ),
            ),
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 8),
            child: Icon(
              Icons.military_tech,
              color: rankColor.withValues(alpha: 0.6),
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
