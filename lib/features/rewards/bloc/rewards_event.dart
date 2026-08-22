import 'package:equatable/equatable.dart';
import 'package:fireguard_app/features/rewards/data/models/coupon_model.dart';

abstract class RewardsEvent extends Equatable {
  const RewardsEvent();
  @override
  List<Object?> get props => [];
}

class RewardsStarted extends RewardsEvent {}

class RewardsCouponRedeemed extends RewardsEvent {
  final CouponModel coupon;
  final int userPoints;
  final String? userId;

  const RewardsCouponRedeemed({
    required this.coupon,
    required this.userPoints,
    this.userId,
  });

  @override
  List<Object?> get props => [coupon, userPoints, userId];
}
