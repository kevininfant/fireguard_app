import 'package:flutter/material.dart';
import 'package:fireguard_app/core/constants/app_colors.dart';

class OptionCard extends StatelessWidget {
  final String label; // 'A', 'B', 'C', 'D'
  final String text;
  final bool isSelected;
  final VoidCallback onSelect;

  const OptionCard({
    super.key,
    required this.label,
    required this.text,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected ? AppColors.industrialOrange : AppColors.outlineVariantColor;
    final containerColor = isSelected ? AppColors.surfaceContainerHigh : AppColors.surfaceContainerLow;

    return GestureDetector(
      onTap: onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: isSelected ? 2.0 : 1.0),
        ),
        child: Row(
          children: [
            // Letter Badge (A, B, C, D)
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.industrialOrange : AppColors.surfaceContainerHigh,
                border: Border.all(
                  color: isSelected ? AppColors.industrialOrange : AppColors.outlineVariantColor,
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppColors.onIndustrialOrange : AppColors.onSurfaceText,
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Option Text
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.onSurfaceText : AppColors.onSurfaceVariantText,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
