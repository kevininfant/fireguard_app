import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fireguard_app/core/constants/app_colors.dart';
import 'package:fireguard_app/core/widgets/loading_view.dart';
import 'package:fireguard_app/features/auth/bloc/auth_bloc.dart';
import 'package:fireguard_app/features/auth/bloc/auth_state.dart';
import 'package:fireguard_app/features/leaderboard/bloc/leaderboard_bloc.dart';
import 'package:fireguard_app/features/leaderboard/bloc/leaderboard_event.dart';
import 'package:fireguard_app/features/leaderboard/bloc/leaderboard_state.dart';
import 'package:fireguard_app/features/leaderboard/widgets/leaderboard_podium.dart';
import 'package:fireguard_app/features/leaderboard/widgets/leaderboard_tile.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  static const List<String> categories = ['Weekly', 'All-Time', 'Industry Rank'];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final currentUserName = authState.user?.displayName ?? 'Alex Rivera';

        return BlocBuilder<LeaderboardBloc, LeaderboardState>(
          builder: (context, state) {
            if (state.status == LeaderboardStatus.loading && state.users.isEmpty) {
              return const LoadingView(message: 'Loading Global Rankings...');
            }

            final topThree = state.users.take(3).toList();
            final remainingUsers = state.users.skip(3).toList();

            return RefreshIndicator(
              onRefresh: () async {
                context.read<LeaderboardBloc>().add(LeaderboardStarted());
              },
              color: AppColors.industrialOrange,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Filter Tabs
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: categories.map((cat) {
                            final isSelected = cat == state.selectedCategory;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  context.read<LeaderboardBloc>().add(LeaderboardCategoryChanged(cat));
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppColors.industrialOrange : Colors.transparent,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    cat.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                      color: isSelected ? AppColors.onIndustrialOrange : AppColors.onSurfaceVariantText,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Top 3 Podium
                    LeaderboardPodium(topThree: topThree),
                    const SizedBox(height: 16),

                    // Remaining Rankings List
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Text(
                        'FIELD INSPECTOR RANKINGS',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                          color: AppColors.onSurfaceVariantText,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: remainingUsers.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final user = remainingUsers[index];
                        final isMe = user.displayName.toLowerCase() == currentUserName.toLowerCase();
                        return LeaderboardTile(
                          user: user,
                          isCurrentUser: isMe,
                        );
                      },
                    ),
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
