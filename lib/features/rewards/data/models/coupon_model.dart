import 'package:equatable/equatable.dart';

class CouponModel extends Equatable {
  final String id;
  final String partnerName;
  final String promoTitle;
  final String discount;
  final String code;
  final int pointsCost;
  final bool isActive;
  final bool isClaimed;
  final String description;

  const CouponModel({
    required this.id,
    required this.partnerName,
    required this.promoTitle,
    required this.discount,
    required this.code,
    required this.pointsCost,
    this.isActive = true,
    this.isClaimed = false,
    required this.description,
  });

  CouponModel copyWith({
    String? id,
    String? partnerName,
    String? promoTitle,
    String? discount,
    String? code,
    int? pointsCost,
    bool? isActive,
    bool? isClaimed,
    String? description,
  }) {
    return CouponModel(
      id: id ?? this.id,
      partnerName: partnerName ?? this.partnerName,
      promoTitle: promoTitle ?? this.promoTitle,
      discount: discount ?? this.discount,
      code: code ?? this.code,
      pointsCost: pointsCost ?? this.pointsCost,
      isActive: isActive ?? this.isActive,
      isClaimed: isClaimed ?? this.isClaimed,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'partnerName': partnerName,
      'promoTitle': promoTitle,
      'discount': discount,
      'code': code,
      'pointsCost': pointsCost,
      'isActive': isActive,
      'isClaimed': isClaimed,
      'description': description,
    };
  }

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['id'] ?? json['code'] ?? 'coup_1',
      partnerName: json['partnerName'] ?? json['partner_name'] ?? 'EHS Safety Partner',
      promoTitle: json['promoTitle'] ?? json['promo_title'] ?? json['discount'] ?? 'Safety Voucher',
      discount: json['discount'] ?? '20% OFF',
      code: json['code'] ?? 'FIREGUARD2026',
      pointsCost: json['pointsCost'] ?? json['points_cost'] ?? json['requiredPoints'] ?? 500,
      isActive: json['isActive'] ?? true,
      isClaimed: json['isClaimed'] ?? false,
      description: json['description'] ?? 'Redeemable for certified personal protective safety equipment.',
    );
  }

  @override
  List<Object?> get props => [
        id,
        partnerName,
        promoTitle,
        discount,
        code,
        pointsCost,
        isActive,
        isClaimed,
        description,
      ];
}
