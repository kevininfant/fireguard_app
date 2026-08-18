import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fireguard_app/core/constants/app_colors.dart';
import 'package:fireguard_app/core/constants/asset_paths.dart';
import 'package:fireguard_app/core/utils/app_helpers.dart';
import 'package:fireguard_app/core/widgets/common_button.dart';
import 'package:fireguard_app/features/auth/bloc/auth_bloc.dart';
import 'package:fireguard_app/features/auth/bloc/auth_event.dart';
import 'package:fireguard_app/features/auth/bloc/auth_state.dart';
import 'package:fireguard_app/features/profile/bloc/profile_bloc.dart';
import 'package:fireguard_app/features/profile/bloc/profile_state.dart';
import 'package:fireguard_app/features/profile/widgets/badge_grid_card.dart';
import 'package:fireguard_app/features/profile/widgets/edit_designation_dialog.dart';
import 'package:fireguard_app/routes/app_routes.dart';

class ProfilePage extends StatelessWidget {
  final bool isStandalone;

  const ProfilePage({super.key, this.isStandalone = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final user = authState.user;
        final name = user?.displayName ?? 'Alex Rivera';
        final role = user?.role ?? 'EHS Manager';
        final email = user?.email ?? 'inspector@fireguard.org';
        final points = user?.points ?? 1250;
        final currentLevel = user?.currentLevel ?? 3;
        final streak = user?.streakDays ?? 5;

        final content = SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.surfaceContainerHighest),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Avatar with level badge
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.industrialOrange, width: 2),
                                image: const DecorationImage(
                                  image: NetworkImage(AssetPaths.defaultAvatar),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              width: 22,
                              height: 22,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: AppColors.industrialOrange,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '$currentLevel',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onIndustrialOrange,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),

                        // Name & Role
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onSurfaceText,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                email,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textMuted,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.industrialOrange.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: AppColors.industrialOrange.withValues(alpha: 0.4),
                                      ),
                                    ),
                                    child: Text(
                                      role.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.industrialOrange,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => EditDesignationDialog(
                                          currentDesignation: role,
                                          onSave: (newRole) {
                                            if (user != null) {
                                              final updated = user.copyWith(role: newRole);
                                              context.read<AuthBloc>().add(AuthUserUpdated(updated));
                                            }
                                          },
                                        ),
                                      );
                                    },
                                    child: const Icon(
                                      Icons.edit,
                                      color: AppColors.onSurfaceVariantText,
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Gamification Row Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.darkBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.outlineVariantColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildPillItem('CURRENT LEVEL', 'Level $currentLevel', AppColors.industrialOrange),
                          Container(width: 1, height: 24, color: AppColors.outlineVariantColor),
                          _buildPillItem('SAFETY POINTS', AppHelpers.formatPoints(points), AppColors.industrialGold),
                          Container(width: 1, height: 24, color: AppColors.outlineVariantColor),
                          _buildPillItem('STREAK', '🔥 $streak-Day', AppColors.onSurfaceText),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Badges Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'OFFICER MERIT BADGES',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                      color: AppColors.onSurfaceVariantText,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.badges);
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.industrialOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Badges Grid
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, profileState) {
                  final badges = profileState.badges.take(4).toList();
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.25,
                    ),
                    itemCount: badges.length,
                    itemBuilder: (context, index) {
                      return BadgeGridCard(badge: badges[index]);
                    },
                  );
                },
              ),
              const SizedBox(height: 24),

              // Quick Actions / Logout
              CommonButton(
                text: 'SWITCH CLEARANCE / LOG OUT',
                isOutlined: true,
                backgroundColor: AppColors.safetyRed,
                textColor: AppColors.safetyRed,
                icon: Icons.logout,
                onPressed: () {
                  context.read<AuthBloc>().add(AuthLogoutRequested());
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.auth,
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        );

        if (isStandalone) {
          return Scaffold(
            backgroundColor: AppColors.darkBackground,
            appBar: AppBar(
              title: const Text('Officer Profile'),
            ),
            body: content,
          );
        }

        return content;
      },
    );
  }

  Widget _buildPillItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: AppColors.onSurfaceVariantText,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
