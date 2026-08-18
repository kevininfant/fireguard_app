import 'package:flutter/material.dart';
import 'package:fireguard_app/core/constants/app_colors.dart';

class SsoButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const SsoButton({
    super.key,
    required this.onPressed,
    this.text = 'SIGN IN WITH GOOGLE SSO',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.onSurfaceText,
          side: const BorderSide(color: AppColors.outlineVariantColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: AppColors.surfaceContainerLow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.g_mobiledata, size: 28, color: AppColors.industrialGold),
            const SizedBox(width: 6),
            Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
                color: AppColors.onSurfaceText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
