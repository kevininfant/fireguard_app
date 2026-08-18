import 'package:equatable/equatable.dart';
import 'package:fireguard_app/features/rewards/data/models/coupon_model.dart';

enum RewardsStatus { initial, loading, success, failure }

class RewardsState extends Equatable {
  final RewardsStatus status;
  final List<CouponModel> coupons;
  final String? message;
  final String? errorMessage;

  const RewardsState({
    this.status = RewardsStatus.initial,
    this.coupons = const [],
    this.message,
    this.errorMessage,
  });

  RewardsState copyWith({
    RewardsStatus? status,
    List<CouponModel>? coupons,
    String? message,
    String? errorMessage,
  }) {
    return RewardsState(
      status: status ?? this.status,
      coupons: coupons ?? this.coupons,
      message: message,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, coupons, message, errorMessage];
}
