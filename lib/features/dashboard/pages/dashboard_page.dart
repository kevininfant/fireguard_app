import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fireguard_app/core/constants/app_colors.dart';
import 'package:fireguard_app/core/widgets/loading_view.dart';
import 'package:fireguard_app/features/auth/bloc/auth_bloc.dart';
import 'package:fireguard_app/features/auth/bloc/auth_state.dart';
import 'package:fireguard_app/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:fireguard_app/features/dashboard/bloc/dashboard_event.dart';
import 'package:fireguard_app/features/dashboard/bloc/dashboard_state.dart';
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

            final levels = dashboardState.levels;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<DashboardBloc>().add(DashboardRefreshRequested());
              },
              color: AppColors.industrialOrange,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats Row
                    StatsRowCard(user: user),
                    const SizedBox(height: 16),

                    // Daily Challenge
                    DailyChallengeCard(
                      onStartDrill: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.quiz,
                          arguments: 3, // Level 3 drill
                        );
                      },
                    ),
                    const SizedBox(height: 20),

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
                          '${levels.length} Dynamic Levels',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.industrialOrange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Level Grid (3 Columns matching Kotlin Grid)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.72,
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
                    ),
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
}
