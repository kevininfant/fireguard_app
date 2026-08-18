import 'package:flutter/material.dart';
import 'package:fireguard_app/core/constants/app_colors.dart';

class DailyChallengeCard extends StatelessWidget {
  final VoidCallback onStartDrill;

  const DailyChallengeCard({super.key, required this.onStartDrill});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceContainerHighest),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left Safety Gold Strip
            Container(
              width: 6,
              decoration: const BoxDecoration(
                color: AppColors.industrialGold,
                borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
              ),
            ),

            // Main Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.campaign, color: AppColors.industrialGold, size: 18),
                        SizedBox(width: 6),
                        Text(
                          'DAILY CHALLENGE',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
                            color: AppColors.industrialGold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Hazard Identification Drill',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurfaceText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Complete a 5-minute spotting drill in Sector 4 to earn 50 bonus points and maintain your streak.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariantText,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: onStartDrill,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.industrialOrange,
                        foregroundColor: AppColors.onIndustrialOrange,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      child: const Text(
                        'START DRILL',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
