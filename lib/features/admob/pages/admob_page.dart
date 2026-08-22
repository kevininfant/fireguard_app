import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fireguard_app/core/constants/app_colors.dart';
import 'package:fireguard_app/core/services/admob_service.dart';
import 'package:fireguard_app/core/utils/app_helpers.dart';
import 'package:fireguard_app/features/admob/widgets/ad_banner_widget.dart';
import 'package:fireguard_app/features/auth/bloc/auth_bloc.dart';
import 'package:fireguard_app/features/auth/bloc/auth_event.dart';
import 'package:fireguard_app/features/auth/bloc/auth_state.dart';

class AdMobPage extends StatefulWidget {
  const AdMobPage({super.key});

  @override
  State<AdMobPage> createState() => _AdMobPageState();
}

class _AdMobPageState extends State<AdMobPage> {
  bool _isLoadingAd = false;
  int _claimedAdsCount = 0;
  bool _hasMultiplierActive = false;

  void _onWatchRewardedAd(BuildContext context, int currentPoints) async {
    setState(() => _isLoadingAd = true);

    await AdMobService().showRewardedAd(
      onRewardEarned: (pointsEarned) {
        final totalGained = _hasMultiplierActive ? pointsEarned * 2 : pointsEarned;
        final authState = context.read<AuthBloc>().state;
        final currentUser = authState.user;

        if (currentUser != null) {
          final updatedUser = currentUser.copyWith(
            points: currentUser.points + totalGained,
          );
          context.read<AuthBloc>().add(AuthUserUpdated(updatedUser));
        }

        setState(() {
          _claimedAdsCount += 1;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.stars, color: AppColors.industrialGold),
                const SizedBox(width: 8),
                Text('+$totalGained Safety Points credited from AdMob Reward!'),
              ],
            ),
            backgroundColor: AppColors.successGreen,
          ),
        );
      },
      onAdClosed: () {
        if (mounted) setState(() => _isLoadingAd = false);
      },
      onAdFailed: (error) {
        if (mounted) {
          setState(() => _isLoadingAd = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ad notice: $error (150 bonus points granted in simulation mode)'),
              backgroundColor: AppColors.industrialOrange,
            ),
          );
        }
      },
    );
  }

  void _onWatchInterstitialAd(BuildContext context) async {
    setState(() => _isLoadingAd = true);

    await AdMobService().showInterstitialAd(
      onAdClosed: () {
        final authState = context.read<AuthBloc>().state;
        final currentUser = authState.user;

        if (currentUser != null) {
          final updatedUser = currentUser.copyWith(
            points: currentUser.points + 50,
          );
          context.read<AuthBloc>().add(AuthUserUpdated(updatedUser));
        }

        if (mounted) {
          setState(() {
            _isLoadingAd = false;
            _claimedAdsCount += 1;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('+50 Safety Points earned from sponsor drill!'),
              backgroundColor: AppColors.successGreen,
            ),
          );
        }
      },
      onAdFailed: (error) {
        if (mounted) {
          setState(() => _isLoadingAd = false);
        }
      },
    );
  }

  void _onActivateMultiplier(BuildContext context) async {
    setState(() => _isLoadingAd = true);

    await AdMobService().showRewardedAd(
      onRewardEarned: (_) {
        setState(() {
          _hasMultiplierActive = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⚡ 2X AdMob Safety Points Multiplier Activated!'),
            backgroundColor: AppColors.industrialGold,
          ),
        );
      },
      onAdClosed: () {
        if (mounted) setState(() => _isLoadingAd = false);
      },
      onAdFailed: (_) {
        if (mounted) setState(() => _isLoadingAd = false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final user = authState.user;
        final userPoints = user?.points ?? 500;
        final userLevel = user?.currentLevel ?? 1;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
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
                          children: const [
                            Text(
                              'GOOGLE ADMOB REWARD HUB',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                                color: AppColors.industrialOrange,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Earn Free Safety Clearance Points',
                              style: TextStyle(
                                fontSize: 16,
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
                            Icons.ad_units,
                            color: AppColors.industrialOrange,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Balance Display Strip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.darkBackground,
                        borderRadius: BorderRadius.circular(12),
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
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'CURRENT BALANCE',
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.industrialGold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: _hasMultiplierActive
                                  ? AppColors.industrialGold.withValues(alpha: 0.2)
                                  : AppColors.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: _hasMultiplierActive
                                    ? AppColors.industrialGold
                                    : AppColors.outlineVariantColor,
                              ),
                            ),
                            child: Text(
                              _hasMultiplierActive ? '⚡ 2X BOOST ACTIVE' : 'LEVEL $userLevel OFFICER',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: _hasMultiplierActive
                                    ? AppColors.industrialGold
                                    : AppColors.industrialOrange,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Live AdMob Banner Ad Slot
              const Text(
                'LIVE SPONSOR BANNER',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                  color: AppColors.onSurfaceVariantText,
                ),
              ),
              const SizedBox(height: 8),
              const AdBannerWidget(),
              const SizedBox(height: 20),

              // Rewarded Ads Actions List
              const Text(
                'ADMOB REWARD DRILLS & BONUSES',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                  color: AppColors.onSurfaceVariantText,
                ),
              ),
              const SizedBox(height: 10),

              // Action 1: Rewarded Video (+150 Pts)
              _buildRewardCard(
                icon: Icons.play_circle_filled,
                iconColor: AppColors.industrialOrange,
                title: 'Watch AdMob Rewarded Video',
                subtitle: 'Watch a short certified industrial safety video sponsor to earn bonus clearance points.',
                pointsBadge: '+150 PTS',
                buttonText: _isLoadingAd ? 'LOADING AD...' : 'WATCH VIDEO (+150)',
                onPressed: _isLoadingAd ? null : () => _onWatchRewardedAd(context, userPoints),
              ),
              const SizedBox(height: 12),

              // Action 2: Interstitial Drill (+50 Pts)
              _buildRewardCard(
                icon: Icons.flash_on,
                iconColor: AppColors.industrialGold,
                title: 'Quick Sponsor Interstitial',
                subtitle: 'View an instant sponsor announcement to boost your officer leaderboard rank.',
                pointsBadge: '+50 PTS',
                buttonText: _isLoadingAd ? 'LOADING...' : 'VIEW SPONSOR (+50)',
                onPressed: _isLoadingAd ? null : () => _onWatchInterstitialAd(context),
              ),
              const SizedBox(height: 12),

              // Action 3: 2X Multiplier Boost
              _buildRewardCard(
                icon: Icons.bolt,
                iconColor: const Color(0xFFFF9800),
                title: '2X Safety Multiplier Boost',
                subtitle: 'Doubles all safety point rewards earned from watching AdMob bonus video drills today.',
                pointsBadge: '2X BOOST',
                buttonText: _hasMultiplierActive ? 'BOOST ACTIVE' : 'UNLOCK 2X BOOST',
                isHighlighted: _hasMultiplierActive,
                onPressed: (_isLoadingAd || _hasMultiplierActive)
                    ? null
                    : () => _onActivateMultiplier(context),
              ),
              const SizedBox(height: 24),

              // Summary Stats Row
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.outlineVariantColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('TOTAL ADS CLAIMED', '$_claimedAdsCount', AppColors.industrialOrange),
                    Container(width: 1, height: 28, color: AppColors.outlineVariantColor),
                    _buildStatItem('POINTS EARNED', '+${_claimedAdsCount * 150} PTS', AppColors.industrialGold),
                    Container(width: 1, height: 28, color: AppColors.outlineVariantColor),
                    _buildStatItem('STATUS', 'ACTIVE', AppColors.successGreen),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRewardCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String pointsBadge,
    required String buttonText,
    required VoidCallback? onPressed,
    bool isHighlighted = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isHighlighted ? AppColors.industrialGold : AppColors.surfaceContainerHighest,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: iconColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurfaceText,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.industrialGold.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.industrialGold.withValues(alpha: 0.5)),
                ),
                child: Text(
                  pointsBadge,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.industrialGold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.onSurfaceVariantText,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: isHighlighted ? AppColors.surfaceContainerHighest : AppColors.industrialOrange,
                foregroundColor: isHighlighted ? AppColors.industrialGold : AppColors.onIndustrialOrange,
                disabledBackgroundColor: AppColors.surfaceContainerHighest,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                buttonText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: isHighlighted
                      ? AppColors.industrialGold
                      : (onPressed == null ? AppColors.textMuted : AppColors.onIndustrialOrange),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
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
        const SizedBox(height: 3),
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
