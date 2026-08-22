import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fireguard_app/core/constants/app_colors.dart';
import 'package:fireguard_app/core/utils/app_helpers.dart';
import 'package:fireguard_app/core/widgets/loading_view.dart';
import 'package:fireguard_app/features/auth/bloc/auth_bloc.dart';
import 'package:fireguard_app/features/auth/bloc/auth_event.dart';
import 'package:fireguard_app/features/auth/bloc/auth_state.dart';
import 'package:fireguard_app/features/rewards/bloc/rewards_bloc.dart';
import 'package:fireguard_app/features/rewards/bloc/rewards_event.dart';
import 'package:fireguard_app/features/rewards/bloc/rewards_state.dart';
import 'package:fireguard_app/features/rewards/widgets/coupon_card.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    context.read<RewardsBloc>().add(RewardsStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final user = authState.user;
        final userPoints = user?.points ?? 500;

        return BlocConsumer<RewardsBloc, RewardsState>(
          listener: (context, state) {
            if (state.message != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message!),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            }
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: AppColors.safetyRed,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.status == RewardsStatus.loading && state.coupons.isEmpty) {
              return const LoadingView(message: 'Loading Store Rewards from Firestore...');
            }

            final allCoupons = state.coupons;
            final claimedCount = allCoupons.where((c) => c.isClaimed).length;

            final filteredCoupons = switch (_selectedFilter) {
              'Available' => allCoupons.where((c) => !c.isClaimed && userPoints >= c.pointsCost).toList(),
              'Claimed' => allCoupons.where((c) => c.isClaimed).toList(),
              _ => allCoupons,
            };

            return RefreshIndicator(
              onRefresh: () async {
                context.read<RewardsBloc>().add(RewardsStarted());
              },
              color: AppColors.industrialOrange,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Balance & Store Banner Card
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'OFFICER REWARD STORE',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0,
                                      color: AppColors.onSurfaceVariantText,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'PPE & Safety Equipment Vouchers',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.onSurfaceText,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainerHigh,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColors.industrialOrange.withValues(alpha: 0.5),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.storefront,
                                  color: AppColors.industrialOrange,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Points Balance Strip
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.darkBackground,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.outlineVariantColor),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.military_tech,
                                      color: AppColors.industrialGold,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'YOUR SAFETY POINTS',
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.5,
                                            color: AppColors.onSurfaceVariantText,
                                          ),
                                        ),
                                        Text(
                                          AppHelpers.formatPoints(userPoints),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.industrialGold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceContainerHigh,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '$claimedCount UNLOCKED',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                      color: AppColors.industrialOrange,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Filter Chips Row
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('All', 'ALL VOUCHERS (${allCoupons.length})'),
                          const SizedBox(width: 8),
                          _buildFilterChip('Available', 'READY TO UNLOCK'),
                          const SizedBox(width: 8),
                          _buildFilterChip('Claimed', 'MY UNLOCKED ($claimedCount)'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Dynamic Section Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'FIRESTORE PARTNER VOUCHERS',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
                            color: AppColors.onSurfaceVariantText,
                          ),
                        ),
                        Text(
                          '${filteredCoupons.length} AVAILABLE',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.industrialOrange,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Coupons List
                    if (filteredCoupons.isEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            const Icon(
                              Icons.card_giftcard,
                              size: 48,
                              color: AppColors.onSurfaceVariantText,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'No Vouchers Match Filter',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.onSurfaceText,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Earn points by completing NFPA hazard drills to unlock exclusive PPE rewards.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.onSurfaceVariantText,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredCoupons.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final coupon = filteredCoupons[index];
                          return CouponCard(
                            coupon: coupon,
                            userPoints: userPoints,
                            onRedeem: () {
                              context.read<RewardsBloc>().add(
                                RewardsCouponRedeemed(
                                  coupon: coupon,
                                  userPoints: userPoints,
                                  userId: user?.uid,
                                ),
                              );

                              // Update points in user session
                              if (user != null && userPoints >= coupon.pointsCost) {
                                final remaining = userPoints - coupon.pointsCost;
                                final updatedUser = user.copyWith(
                                  points: remaining,
                                  unlockedCoupons: [...user.unlockedCoupons, coupon.id],
                                );
                                context.read<AuthBloc>().add(AuthUserUpdated(updatedUser));
                              }
                            },
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

  Widget _buildFilterChip(String filterKey, String label) {
    final isSelected = _selectedFilter == filterKey;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = filterKey),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.industrialOrange : AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.industrialOrange : AppColors.outlineVariantColor,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: isSelected ? AppColors.onIndustrialOrange : AppColors.onSurfaceText,
          ),
        ),
      ),
    );
  }
}
