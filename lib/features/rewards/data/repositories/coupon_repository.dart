import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fireguard_app/features/rewards/data/models/coupon_model.dart';

class CouponRepository {
  static const String _couponsKey = 'fireguard_coupons_data';

  final List<CouponModel> _defaultCoupons = const [
    CouponModel(
      id: 'coup_1',
      partnerName: '3M Safety Direct',
      promoTitle: '20% OFF Respirators & PPE Gear',
      discount: '20% OFF',
      code: '3MSAFE2026',
      pointsCost: 500,
      isActive: true,
      description: 'Valid for all certified 3M personal protective equipment and filters.',
    ),
    CouponModel(
      id: 'coup_2',
      partnerName: 'MSA Safety Global',
      promoTitle: '15% OFF Gas Detectors & Harnesses',
      discount: '15% OFF',
      code: 'MSAGUARD15',
      pointsCost: 750,
      isActive: true,
      description: 'Discount code applicable to industrial multi-gas monitor kits.',
    ),
    CouponModel(
      id: 'coup_3',
      partnerName: 'Duluth Workwear',
      promoTitle: '\$25 OFF Flame-Resistant Outerwear',
      discount: '\$25 OFF',
      code: 'DULUTHFIRE25',
      pointsCost: 1000,
      isActive: true,
      description: 'Redeemable online at Duluth Trading for NFPA-rated work apparel.',
    ),
    CouponModel(
      id: 'coup_4',
      partnerName: 'Honeywell Industrial',
      promoTitle: 'Free NFPA Inspection Stencil Set',
      discount: 'FREE STENCIL',
      code: 'HONEYWELLFREE',
      pointsCost: 1500,
      isActive: true,
      description: 'Free stencil kit shipped directly to registered safety officers.',
    ),
  ];

  Future<List<CouponModel>> getCoupons() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_couponsKey);
    if (data != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(data);
        return jsonList.map((e) => CouponModel.fromJson(e)).toList();
      } catch (_) {}
    }
    await saveCoupons(_defaultCoupons);
    return _defaultCoupons;
  }

  Future<void> saveCoupons(List<CouponModel> coupons) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(coupons.map((e) => e.toJson()).toList());
    await prefs.setString(_couponsKey, data);
  }

  Future<bool> redeemCoupon(String couponId) async {
    final current = await getCoupons();
    final updated = current.map((c) {
      if (c.id == couponId) {
        return c.copyWith(isClaimed: true);
      }
      return c;
    }).toList();
    await saveCoupons(updated);
    return true;
  }
}
