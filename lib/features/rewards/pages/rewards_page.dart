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

class RewardsPage extends StatelessWidget {
  const RewardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final user = authState.user;
        final userPoints = user?.points ?? 1250;

        return BlocConsumer<RewardsBloc, RewardsState>(
          listener: (context, state) {
            if (state.message != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message!),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            } else if (state.errorMessage != null) {
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
              return const LoadingView(message: 'Loading Partner Rewards...');
            }

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
                    // Available Balance Banner
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.industrialGold.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'AVAILABLE SAFETY BALANCE',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                  color: AppColors.onSurfaceVariantText,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                AppHelpers.formatPoints(userPoints),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.industrialGold,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.industrialGold),
                            ),
                            child: const Icon(
                              Icons.redeem,
                              color: AppColors.industrialGold,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Section Title
                    const Text(
                      'EXCLUSIVE SAFETY PARTNER DISCOUNTS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                        color: AppColors.onSurfaceVariantText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Redeem safety certification points for certified PPE gear vouchers.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Coupons List
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.coupons.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final coupon = state.coupons[index];
                        return CouponCard(
                          coupon: coupon,
                          userPoints: userPoints,
                          onRedeem: () {
                            context.read<RewardsBloc>().add(
                                  RewardsCouponRedeemed(
                                    coupon: coupon,
                                    userPoints: userPoints,
                                  ),
                                );
                            if (user != null && userPoints >= coupon.pointsCost) {
                              final updatedUser = user.copyWith(
                                points: user.points - coupon.pointsCost,
                                unlockedCoupons: [...user.unlockedCoupons, coupon.code],
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
}
