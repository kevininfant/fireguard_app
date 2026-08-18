import 'package:flutter/material.dart';
import 'package:fireguard_app/core/constants/app_colors.dart';
import 'package:fireguard_app/core/utils/app_helpers.dart';
import 'package:fireguard_app/features/auth/data/models/user_model.dart';

class StatsRowCard extends StatelessWidget {
  final User? user;

  const StatsRowCard({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    final streak = user?.streakDays ?? 3;
    final points = user?.points ?? 1250;
    final role = user?.role ?? 'Safety Inspector';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.surfaceContainerHighest),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Streak
          Row(
            children: [
              const Icon(
                Icons.local_fire_department,
                color: AppColors.industrialGold,
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                '$streak Days Streak',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurfaceText,
                ),
              ),
            ],
          ),

          // Points
          Row(
            children: [
              const Icon(
                Icons.military_tech,
                color: AppColors.industrialOrange,
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                AppHelpers.formatPoints(points),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.industrialOrange,
                ),
              ),
            ],
          ),

          // Role Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              role.toUpperCase(),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
                color: AppColors.onSurfaceVariantText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
