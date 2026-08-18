enum CouponStatus { available, redeemed, expired }

class CouponModel {
  const CouponModel({required this.id, required this.title, required this.description, required this.expiresAt, required this.pointsCost, required this.rules, this.allowMultipleRedemptions = false});
  final String id;
  final String title;
  final String description;
  final DateTime expiresAt;
  final int pointsCost;
  final String rules;
  final bool allowMultipleRedemptions;
}
