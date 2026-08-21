import 'package:flutter/material.dart';
import 'package:fireguard_app/core/constants/app_colors.dart';

class RewardsPage extends StatelessWidget {
  const RewardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.construction,
              color: AppColors.industrialOrange,
              size: 54,
            ),
            SizedBox(height: 16),
            Text(
              'Coming Soon',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.onSurfaceText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
