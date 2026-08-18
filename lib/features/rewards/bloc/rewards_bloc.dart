import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fireguard_app/features/rewards/bloc/rewards_event.dart';
import 'package:fireguard_app/features/rewards/bloc/rewards_state.dart';
import 'package:fireguard_app/features/rewards/data/repositories/coupon_repository.dart';

class RewardsBloc extends Bloc<RewardsEvent, RewardsState> {
  final CouponRepository _couponRepository;

  RewardsBloc({CouponRepository? couponRepository})
      : _couponRepository = couponRepository ?? CouponRepository(),
        super(const RewardsState()) {
    on<RewardsStarted>(_onStarted);
    on<RewardsCouponRedeemed>(_onCouponRedeemed);
  }

  Future<void> _onStarted(
    RewardsStarted event,
    Emitter<RewardsState> emit,
  ) async {
    emit(state.copyWith(status: RewardsStatus.loading));
    try {
      final coupons = await _couponRepository.getCoupons();
      emit(state.copyWith(
        status: RewardsStatus.success,
        coupons: coupons,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: RewardsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onCouponRedeemed(
    RewardsCouponRedeemed event,
    Emitter<RewardsState> emit,
  ) async {
    if (event.userPoints < event.coupon.pointsCost) {
      final needed = event.coupon.pointsCost - event.userPoints;
      emit(state.copyWith(
        errorMessage: 'Earn $needed more points to unlock this voucher!',
      ));
      return;
    }

    try {
      await _couponRepository.redeemCoupon(event.coupon.id);
      final coupons = await _couponRepository.getCoupons();
      emit(state.copyWith(
        status: RewardsStatus.success,
        coupons: coupons,
        message: 'Voucher ${event.coupon.code} unlocked successfully!',
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}
