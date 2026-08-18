import 'package:flutter/material.dart';
import 'package:fireguard_app/core/constants/app_colors.dart';

class FireGuardTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? userRole;
  final VoidCallback onOpenDrawer;
  final VoidCallback onProfileClick;

  const FireGuardTopBar({
    super.key,
    this.title = 'FireGuard Safety',
    this.userRole,
    required this.onOpenDrawer,
    required this.onProfileClick,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surfaceContainerLow,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: AppColors.onSurfaceText),
        onPressed: onOpenDrawer,
      ),
      title: Row(
        children: [
          const Icon(Icons.local_fire_department, color: AppColors.industrialOrange, size: 20),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.industrialOrange,
            ),
          ),
        ],
      ),
      actions: [
        if (userRole != null)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 14),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              userRole!.toUpperCase(),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurfaceVariantText,
              ),
            ),
          ),
        IconButton(
          icon: const Icon(Icons.account_circle, color: AppColors.onSurfaceVariantText),
          onPressed: onProfileClick,
        ),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: AppColors.surfaceContainerHighest),
      ),
    );
  }
}
