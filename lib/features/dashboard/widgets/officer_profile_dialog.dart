import 'package:flutter/material.dart';
import 'package:fireguard_app/core/constants/app_colors.dart';
import 'package:fireguard_app/core/utils/app_helpers.dart';
import 'package:fireguard_app/features/auth/data/models/user_model.dart';

class OfficerProfileDialog extends StatelessWidget {
  final User? user;
  final VoidCallback onLogout;

  const OfficerProfileDialog({
    super.key,
    required this.user,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surfaceContainerHigh,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: const [
          Icon(Icons.account_circle, color: AppColors.industrialOrange, size: 24),
          SizedBox(width: 8),
          Text(
            'Officer Profile',
            style: TextStyle(
              color: AppColors.onSurfaceText,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Name', user?.displayName ?? 'Alex Rivera'),
          const SizedBox(height: 8),
          _buildInfoRow('Clearance ID', user?.email ?? 'inspector@fireguard.org'),
          const SizedBox(height: 8),
          _buildInfoRow('Access Role', user?.role ?? 'EHS Manager', isHighlight: true),
          const SizedBox(height: 8),
          _buildInfoRow('Current Level', 'Level ${user?.currentLevel ?? 3}'),
          const SizedBox(height: 8),
          _buildInfoRow(
            'Safety Points',
            AppHelpers.formatPoints(user?.points ?? 1250),
            isGold: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Close',
            style: TextStyle(color: AppColors.onSurfaceVariantText),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onLogout();
          },
          child: const Text(
            'Switch Clearance / Logout',
            style: TextStyle(
              color: AppColors.industrialOrange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isHighlight = false, bool isGold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.onSurfaceVariantText,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: (isHighlight || isGold) ? FontWeight.bold : FontWeight.w500,
            color: isGold
                ? AppColors.industrialGold
                : (isHighlight ? AppColors.industrialOrange : AppColors.onSurfaceText),
          ),
        ),
      ],
    );
  }
}
