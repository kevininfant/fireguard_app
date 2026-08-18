import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fireguard_app/core/constants/app_colors.dart';
import 'package:fireguard_app/core/utils/app_helpers.dart';
import 'package:fireguard_app/features/rewards/data/models/coupon_model.dart';

class CouponCard extends StatelessWidget {
  final CouponModel coupon;
  final int userPoints;
  final VoidCallback onRedeem;

  const CouponCard({
    super.key,
    required this.coupon,
    required this.userPoints,
    required this.onRedeem,
  });

  @override
  Widget build(BuildContext context) {
    final canAfford = userPoints >= coupon.pointsCost;
    final isClaimed = coupon.isClaimed;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isClaimed
              ? AppColors.industrialGold
              : (canAfford ? AppColors.industrialOrange.withValues(alpha: 0.5) : AppColors.surfaceContainerHighest),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.storefront, color: AppColors.industrialOrange, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      coupon.partnerName.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                        color: AppColors.onSurfaceVariantText,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.industrialOrange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    coupon.discount,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.industrialOrange,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coupon.promoTitle,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurfaceText,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  coupon.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariantText,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),

                // Claimed Code Box or Unlock Action
                if (isClaimed) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.industrialGold),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.check_circle, color: AppColors.industrialGold, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              coupon.code,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                color: AppColors.industrialGold,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, color: AppColors.onSurfaceVariantText, size: 18),
                          tooltip: 'Copy Promo Code',
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: coupon.code));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Promo Code ${coupon.code} copied to clipboard!'),
                                backgroundColor: AppColors.successGreen,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.military_tech, color: AppColors.industrialGold, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            AppHelpers.formatPoints(coupon.pointsCost),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.industrialGold,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: canAfford ? onRedeem : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.industrialOrange,
                          foregroundColor: AppColors.onIndustrialOrange,
                          disabledBackgroundColor: AppColors.surfaceContainerHighest,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                        child: Text(
                          canAfford ? 'REDEEM VOUCHER' : 'NEED MORE POINTS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: canAfford ? AppColors.onIndustrialOrange : AppColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
