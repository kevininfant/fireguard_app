import 'package:flutter/material.dart';
import 'package:fireguard_app/core/constants/app_colors.dart';

class NfpaExplanationDialog extends StatelessWidget {
  final String nfpaReference;

  const NfpaExplanationDialog({super.key, required this.nfpaReference});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surfaceContainerHigh,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: const [
          Icon(Icons.menu_book, color: AppColors.industrialGold, size: 22),
          SizedBox(width: 8),
          Text(
            'NFPA Standard Reference',
            style: TextStyle(
              color: AppColors.onSurfaceText,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
              border: const Border(
                left: BorderSide(color: AppColors.industrialGold, width: 4),
              ),
            ),
            child: Text(
              nfpaReference,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceText,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'This standard is mandated by the National Fire Protection Association for industrial facility clearance and life safety auditing.',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.onSurfaceVariantText,
              height: 1.4,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Understood',
            style: TextStyle(
              color: AppColors.industrialOrange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
