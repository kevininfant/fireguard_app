import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fireguard_app/core/constants/app_colors.dart';
import 'package:fireguard_app/core/widgets/loading_view.dart';
import 'package:fireguard_app/features/auth/bloc/auth_bloc.dart';
import 'package:fireguard_app/features/auth/bloc/auth_state.dart';
import 'package:fireguard_app/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:fireguard_app/features/dashboard/bloc/dashboard_event.dart';
import 'package:fireguard_app/features/dashboard/bloc/dashboard_state.dart';
import 'package:fireguard_app/features/dashboard/data/models/level_model.dart';
import 'package:fireguard_app/features/dashboard/widgets/stats_row_card.dart';
import 'package:fireguard_app/features/dashboard/widgets/daily_challenge_card.dart';
import 'package:fireguard_app/features/dashboard/widgets/level_map_card.dart';
import 'package:fireguard_app/routes/app_routes.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final user = authState.user;

        return BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, dashboardState) {
            if (dashboardState.status == DashboardStatus.loading &&
                dashboardState.levels.isEmpty) {
              return const LoadingView(message: 'Loading Safety Modules...');
            }

            final levels = _levelsForUserProgress(
              dashboardState.levels,
              user?.currentLevel,
            );
            final drillLevel =
                levels.where((level) => level.isActive).firstOrNull ??
                levels.where((level) => !level.isLocked).lastOrNull ??
                levels.firstOrNull;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<DashboardBloc>().add(DashboardRefreshRequested());
              },
              color: AppColors.industrialOrange,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats Row
                    StatsRowCard(user: user),
                    const SizedBox(height: 16),

                    // Daily Challenge
                    if (drillLevel != null) ...[
                      DailyChallengeCard(
                        onStartDrill: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.quiz,
                            arguments: drillLevel.levelId,
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Safety Certification Path Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'SAFETY CERTIFICATION PATH',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
                            color: AppColors.onSurfaceVariantText,
                          ),
                        ),
                        Text(
                          levels.isNotEmpty
                              ? '${levels.length} Dynamic Levels'
                              : 'No Data Found',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: levels.isNotEmpty
                                ? AppColors.industrialOrange
                                : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Level Grid or No Data View
                    if (levels.isNotEmpty)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.64,
                            ),
                        itemCount: levels.length,
                        itemBuilder: (context, index) {
                          final level = levels[index];
                          return LevelMapCard(
                            level: level,
                            onClick: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.quiz,
                                arguments: level.levelId,
                              );
                            },
                          );
                        },
                      )
                    else
                      _buildNoDataCard(context),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNoDataCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.surfaceContainerHighest,
          width: 1.2,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.industrialGold.withValues(alpha: 0.15),
              border: Border.all(
                color: AppColors.industrialGold.withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
            child: const Icon(
              Icons.cloud_off_rounded,
              color: AppColors.industrialGold,
              size: 28,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'No Safety Certification Data Found',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurfaceText,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'No levels found in Firebase Firestore collection ("safety_levels"). You can add documents in Firebase Console or seed initial certification modules.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              height: 1.4,
              color: AppColors.onSurfaceVariantText,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  context
                      .read<DashboardBloc>()
                      .add(DashboardSeedFirebaseRequested());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.industrialOrange,
                  foregroundColor: AppColors.onIndustrialOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                ),
                icon: const Icon(Icons.cloud_upload_rounded, size: 16),
                label: const Text(
                  'Seed to Firebase',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: () {
                  context
                      .read<DashboardBloc>()
                      .add(DashboardRefreshRequested());
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.onSurfaceText,
                  side: const BorderSide(
                    color: AppColors.surfaceContainerHighest,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                ),
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: const Text(
                  'Refresh',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<LevelModel> _levelsForUserProgress(
    List<LevelModel> levels,
    int? currentLevel,
  ) {
    if (currentLevel == null || levels.isEmpty) return levels;

    final maxLevel = levels
        .map((level) => level.levelNumber)
        .reduce((currentMax, level) => level > currentMax ? level : currentMax);

    return levels.map((level) {
      if (currentLevel > maxLevel || level.levelNumber < currentLevel) {
        return level.copyWith(status: 'COMPLETED');
      }
      if (level.levelNumber == currentLevel) {
        return level.copyWith(status: 'ACTIVE');
      }
      return level.copyWith(status: 'LOCKED');
    }).toList();
  }
}
