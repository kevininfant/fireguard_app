import 'package:flutter/material.dart';
import 'package:fireguard_app/core/constants/app_colors.dart';

class FireGuardBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const FireGuardBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLow,
        border: Border(
          top: BorderSide(color: AppColors.surfaceContainerHighest, width: 1),
        ),
      ),
      child: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onTabSelected,
        backgroundColor: Colors.transparent,
        indicatorColor: AppColors.industrialOrange.withValues(alpha: 0.2),
        elevation: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.map_outlined, color: AppColors.onSurfaceVariantText),
            selectedIcon: Icon(Icons.map, color: AppColors.industrialOrange),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.rss_feed_outlined, color: AppColors.onSurfaceVariantText),
            selectedIcon: Icon(Icons.rss_feed, color: AppColors.industrialOrange),
            label: 'Feed',
          ),
          NavigationDestination(
            icon: Icon(Icons.leaderboard_outlined, color: AppColors.onSurfaceVariantText),
            selectedIcon: Icon(Icons.leaderboard, color: AppColors.industrialOrange),
            label: 'Engagement',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined, color: AppColors.onSurfaceVariantText),
            selectedIcon: Icon(Icons.shopping_cart, color: AppColors.industrialOrange),
            label: 'Rewards',
          ),
        ],
      ),
    );
  }
}
