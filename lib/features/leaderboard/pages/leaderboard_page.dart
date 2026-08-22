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

  static const List<String> categories = [
    'Weekly',
    'All-Time',
    'Industry Rank',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final currentUserName = authState.user?.displayName ?? 'Alex Rivera';
        final currentUser = authState.user;

        return BlocBuilder<LeaderboardBloc, LeaderboardState>(
          builder: (context, state) {
            if (state.status == LeaderboardStatus.initial) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  context.read<LeaderboardBloc>().add(
                    LeaderboardStarted(currentUser: currentUser),
                  );
                }
              });
            }

            if (state.status == LeaderboardStatus.loading &&
                state.users.isEmpty) {
              return const LoadingView(message: 'Loading Global Rankings...');
            }

            final topThree = state.users.take(3).toList();
            final remainingUsers = state.users.skip(3).toList();

            return RefreshIndicator(
              onRefresh: () async {
                context.read<LeaderboardBloc>().add(
                  LeaderboardStarted(currentUser: currentUser),
                );
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
                                  context.read<LeaderboardBloc>().add(
                                    LeaderboardCategoryChanged(
                                      cat,
                                      currentUser: currentUser,
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.industrialOrange
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    cat.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                      color: isSelected
                                          ? AppColors.onIndustrialOrange
                                          : AppColors.onSurfaceVariantText,
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
                    if (topThree.isNotEmpty) ...[
                      LeaderboardPodium(topThree: topThree),
                      const SizedBox(height: 16),
                    ],

                    // Dynamic Remaining Rankings List Header
                    if (remainingUsers.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _getRankingHeader(state.selectedCategory),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.0,
                                color: AppColors.onSurfaceVariantText,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerHigh,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: AppColors.outlineVariantColor,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.shield_outlined,
                                    size: 12,
                                    color: AppColors.industrialOrange,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${remainingUsers.length} OFFICER${remainingUsers.length == 1 ? '' : 'S'}',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                      color: AppColors.industrialOrange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
                          final isMe = currentUser != null
                              ? user.uid == currentUser.uid
                              : user.displayName.toLowerCase() ==
                                    currentUserName.toLowerCase();
                          return LeaderboardTile(user: user, isCurrentUser: isMe);
                        },
                      ),
                    ] else if (topThree.isEmpty) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                        alignment: Alignment.center,
                        child: Column(
                          children: const [
                            Icon(
                              Icons.leaderboard_outlined,
                              size: 48,
                              color: AppColors.onSurfaceVariantText,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'No Officers Ranked Yet',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.onSurfaceText,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Complete hazard clearance drills to appear on the global leaderboard.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.onSurfaceVariantText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _getRankingHeader(String category) {
    switch (category) {
      case 'Weekly':
        return 'WEEKLY SPRINT STANDINGS';
      case 'Industry Rank':
        return 'INDUSTRY COMPLIANCE STANDINGS';
      case 'All-Time':
      default:
        return 'GLOBAL INSPECTOR RANKINGS';
    }
  }
}
