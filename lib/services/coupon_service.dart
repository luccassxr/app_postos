import '../models/coupon_model.dart';

class CouponException implements Exception { const CouponException(this.message); final String message; }

class CouponService {
  static final coupons = <CouponModel>[
    CouponModel(id: 'wash10', title: '10% OFF na lavagem', description: 'Desconto em uma lavagem selecionada.', expiresAt: DateTime(2027), pointsCost: 100, rules: 'Uso único por cliente.'),
    CouponModel(id: 'coffee', title: 'Café grátis', description: 'Um café na loja de conveniência.', expiresAt: DateTime(2027), pointsCost: 50, rules: 'Uso único por cliente.'),
    CouponModel(id: 'oil', title: 'Desconto na troca de óleo', description: 'Condição especial em serviços selecionados.', expiresAt: DateTime(2027), pointsCost: 300, rules: 'Uso único por cliente.'),
  ];

  void validateRedemption(CouponModel coupon, {required int balance, required bool alreadyRedeemed, DateTime? now}) {
    if (!(now ?? DateTime.now()).isBefore(coupon.expiresAt)) throw const CouponException('Este cupom está expirado.');
    if (alreadyRedeemed && !coupon.allowMultipleRedemptions) throw const CouponException('Este cupom já foi resgatado.');
    if (balance < coupon.pointsCost) throw const CouponException('Saldo de pontos insuficiente.');
  }
}
