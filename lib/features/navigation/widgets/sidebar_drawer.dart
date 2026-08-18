import 'package:flutter/material.dart';
import 'package:fireguard_app/core/constants/app_colors.dart';
import 'package:fireguard_app/core/constants/asset_paths.dart';
import 'package:fireguard_app/core/utils/app_helpers.dart';
import 'package:fireguard_app/features/auth/data/models/user_model.dart';
import 'package:fireguard_app/routes/app_routes.dart';

class SidebarDrawer extends StatelessWidget {
  final User? user;
  final String currentRoute;
  final ValueChanged<String> onNavigate;
  final VoidCallback onLogout;

  const SidebarDrawer({
    super.key,
    required this.user,
    required this.currentRoute,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final userName = user?.displayName ?? 'Alex Rivera';
    final userRole = user?.role ?? 'EHS Manager';
    final userLevel = user?.currentLevel ?? 3;
    final userPoints = user?.points ?? 1250;
    final userStreak = user?.streakDays ?? 5;

    return Drawer(
      backgroundColor: AppColors.surfaceContainer,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand Logo & Header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.industrialOrange.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Image.network(
                              AssetPaths.logoUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.local_fire_department,
                                color: AppColors.industrialOrange,
                                size: 24,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'FIREGUARD',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.0,
                              color: AppColors.industrialOrange,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // User Profile Card
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.outlineVariantColor),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Container(
                                    width: 46,
                                    height: 46,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: AppColors.industrialOrange, width: 2),
                                      image: const DecorationImage(
                                        image: NetworkImage(AssetPaths.defaultAvatar),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 18,
                                    height: 18,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      color: AppColors.industrialOrange,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      '$userLevel',
                                      style: const TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.onIndustrialOrange,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userName,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.onSurfaceText,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.industrialOrange.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        userRole.toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.industrialOrange,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Gamification Row Pill
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.darkBackground,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.outlineVariantColor),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildMiniStat('LEVEL', '$userLevel', AppColors.industrialOrange),
                                Container(width: 1, height: 16, color: AppColors.outlineVariantColor),
                                _buildMiniStat('POINTS', AppHelpers.formatPoints(userPoints), AppColors.industrialGold),
                                Container(width: 1, height: 16, color: AppColors.outlineVariantColor),
                                _buildMiniStat('STREAK', '🔥 $userStreak-D', AppColors.onSurfaceText),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Primary Navigation Links
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        children: [
                          _buildDrawerItem(
                            label: 'DASHBOARD MAP',
                            icon: Icons.map_outlined,
                            selectedIcon: Icons.map,
                            isSelected: currentRoute == AppRoutes.dashboard,
                            onTap: () => onNavigate(AppRoutes.dashboard),
                          ),
                          _buildDrawerItem(
                            label: 'KNOWLEDGE FEED',
                            icon: Icons.rss_feed_outlined,
                            selectedIcon: Icons.rss_feed,
                            isSelected: currentRoute == AppRoutes.feed,
                            onTap: () => onNavigate(AppRoutes.feed),
                          ),
                          _buildDrawerItem(
                            label: 'LEADERBOARD',
                            icon: Icons.leaderboard_outlined,
                            selectedIcon: Icons.leaderboard,
                            isSelected: currentRoute == AppRoutes.leaderboard,
                            onTap: () => onNavigate(AppRoutes.leaderboard),
                          ),
                          _buildDrawerItem(
                            label: 'REWARD STORE',
                            icon: Icons.shopping_cart_outlined,
                            selectedIcon: Icons.shopping_cart,
                            isSelected: currentRoute == AppRoutes.rewards,
                            onTap: () => onNavigate(AppRoutes.rewards),
                          ),
                          _buildDrawerItem(
                            label: 'BOOKMARKED QUESTIONS',
                            icon: Icons.bookmark_border,
                            selectedIcon: Icons.bookmark,
                            isSelected: currentRoute == AppRoutes.bookmarks,
                            onTap: () => onNavigate(AppRoutes.bookmarks),
                          ),
                          _buildDrawerItem(
                            label: 'MY BADGES',
                            icon: Icons.military_tech_outlined,
                            selectedIcon: Icons.military_tech,
                            isSelected: currentRoute == AppRoutes.badges,
                            onTap: () => onNavigate(AppRoutes.badges),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer System Items
            Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.outlineVariantColor)),
              ),
              child: Column(
                children: [
                  _buildDrawerItem(
                    label: 'SETTINGS',
                    icon: Icons.settings_outlined,
                    selectedIcon: Icons.settings,
                    isSelected: currentRoute == AppRoutes.settings,
                    onTap: () => onNavigate(AppRoutes.settings),
                  ),
                  _buildDrawerItem(
                    label: 'HELP & SUPPORT',
                    icon: Icons.help_outline,
                    selectedIcon: Icons.help,
                    isSelected: currentRoute == AppRoutes.help,
                    onTap: () => onNavigate(AppRoutes.help),
                  ),
                  _buildDrawerItem(
                    label: 'SHARE WITH FRIENDS',
                    icon: Icons.share_outlined,
                    selectedIcon: Icons.share,
                    isSelected: false,
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sharing FireGuard Safety App link...'),
                          backgroundColor: AppColors.industrialOrange,
                        ),
                      );
                    },
                  ),
                  // Log Out Button
                  GestureDetector(
                    onTap: onLogout,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.logout, color: AppColors.safetyRed, size: 20),
                          SizedBox(width: 12),
                          Text(
                            'LOG OUT',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                              color: AppColors.safetyRed,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: AppColors.onSurfaceVariantText,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildDrawerItem({
    required String label,
    required IconData icon,
    required IconData selectedIcon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.industrialOrange : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
        leading: Icon(
          isSelected ? selectedIcon : icon,
          color: isSelected ? AppColors.onIndustrialOrange : AppColors.onSurfaceVariantText,
          size: 20,
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: isSelected ? AppColors.onIndustrialOrange : AppColors.onSurfaceVariantText,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
