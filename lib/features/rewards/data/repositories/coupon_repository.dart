import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fireguard_app/features/rewards/data/models/coupon_model.dart';

class CouponRepository {
  static const String _couponsKey = 'fireguard_coupons_cache';
  static const List<String> _collectionCandidates = [
    'coupons',
    'rewards',
    'store_items',
    'store',
  ];

  final FirebaseFirestore _firestore;
  String _activeCollection = 'coupons';

  CouponRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  static const List<CouponModel> defaultSeedCoupons = [
    CouponModel(
      id: 'coup_1',
      partnerName: '3M Safety Direct',
      promoTitle: '20% OFF Respirators & PPE Gear',
      discount: '20% OFF',
      code: '3MSAFE2026',
      pointsCost: 500,
      isActive: true,
      description:
          'Valid for all certified 3M personal protective equipment and chemical filters.',
    ),
    CouponModel(
      id: 'coup_2',
      partnerName: 'MSA Safety Global',
      promoTitle: '15% OFF Gas Detectors & Harnesses',
      discount: '15% OFF',
      code: 'MSAGUARD15',
      pointsCost: 750,
      isActive: true,
      description:
          'Discount code applicable to industrial multi-gas monitor kits and fall arrestors.',
    ),
    CouponModel(
      id: 'coup_3',
      partnerName: 'Duluth Workwear',
      promoTitle: '\$25 OFF Flame-Resistant Outerwear',
      discount: '\$25 OFF',
      code: 'DULUTHFIRE25',
      pointsCost: 1000,
      isActive: true,
      description:
          'Redeemable online at Duluth Trading for NFPA 2112 certified flame-resistant apparel.',
    ),
    CouponModel(
      id: 'coup_4',
      partnerName: 'Honeywell Industrial',
      promoTitle: 'Free NFPA Inspection Stencil Set',
      discount: 'FREE STENCIL',
      code: 'HONEYWELLFREE',
      pointsCost: 1500,
      isActive: true,
      description:
          'Free NFPA safety stencil kit shipped directly to registered safety clearance officers.',
    ),
    CouponModel(
      id: 'coup_5',
      partnerName: 'Grainger Supply',
      promoTitle: '25% OFF Suppression Systems',
      discount: '25% OFF',
      code: 'GRAINGER25',
      pointsCost: 2000,
      isActive: true,
      description:
          'Exclusive commercial rebate for fire extinguishers, hoses, and sprinkler fittings.',
    ),
  ];

  /// Fetches store vouchers purely and dynamically from Cloud Firestore.
  Future<List<CouponModel>> getCoupons() async {
    try {
      for (final col in _collectionCandidates) {
        try {
          final snapshot = await _firestore
              .collection(col)
              .get()
              .timeout(const Duration(seconds: 4));

          if (snapshot.docs.isNotEmpty) {
            _activeCollection = col;
            final items = snapshot.docs.map((doc) {
              return CouponModel.fromJson({
                ...doc.data(),
                'id': doc.id,
              });
            }).toList();

            await _saveToCache(items);
            return items;
          }
        } catch (_) {}
      }

      // If Firestore collection is empty, seed items directly into Firestore
      final seeded = await seedDefaultCouponsToFirebase();
      return seeded;
    } catch (e) {
      debugPrint('CouponRepository getCoupons error: $e');
      final cached = await _getFromCache();
      if (cached.isNotEmpty) return cached;
      return defaultSeedCoupons;
    }
  }

  /// Seeds reward vouchers directly into Cloud Firestore
  Future<List<CouponModel>> seedDefaultCouponsToFirebase() async {
    try {
      final batch = _firestore.batch();
      for (final coupon in defaultSeedCoupons) {
        final docRef = _firestore
            .collection(_activeCollection)
            .doc(coupon.id);

        batch.set(docRef, {
          ...coupon.toJson(),
          'createdAt': FieldValue.serverTimestamp(),
          'isPublished': true,
        }, SetOptions(merge: true));
      }
      await batch.commit();
      await _saveToCache(defaultSeedCoupons);
      return defaultSeedCoupons;
    } catch (e) {
      debugPrint('Failed to seed coupons to Firestore: $e');
      return defaultSeedCoupons;
    }
  }

  /// Dynamically redeems a coupon in Firestore
  Future<bool> redeemCoupon(String couponId, {String? userId, int? userPoints}) async {
    try {
      // Mark claimed in Firestore collection
      await _firestore
          .collection(_activeCollection)
          .doc(couponId)
          .set({'isClaimed': true, 'claimedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));

      // If userId is provided, sync to user profile in Firestore
      if (userId != null && userId.isNotEmpty) {
        await _firestore.collection('users').doc(userId).set({
          'unlockedCoupons': FieldValue.arrayUnion([couponId]),
          if (userPoints != null) 'points': userPoints,
          'lastRedemptionAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint('Firestore redeemCoupon error: $e');
    }

    final current = await _getFromCache();
    if (current.isNotEmpty) {
      final updated = current.map((c) {
        if (c.id == couponId) {
          return c.copyWith(isClaimed: true);
        }
        return c;
      }).toList();
      await _saveToCache(updated);
    }
    return true;
  }

  Future<void> _saveToCache(List<CouponModel> coupons) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(coupons.map((e) => e.toJson()).toList());
    await prefs.setString(_couponsKey, data);
  }

  Future<List<CouponModel>> _getFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_couponsKey);
    if (data != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(data);
        return jsonList.map((e) => CouponModel.fromJson(e)).toList();
      } catch (_) {}
    }
    return [];
  }
}
