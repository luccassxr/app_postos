from pathlib import Path

path = Path('lib/main.dart')
text = path.read_text(encoding='utf-8')

start = text.find('class BenefitsScreen extends StatelessWidget {')
end = text.find('class ProfileScreen', start)
if start == -1 or end == -1:
    raise SystemExit('Benefits/Profile screen markers not found')

replacement = r'''class BenefitsScreen extends StatefulWidget {
  const BenefitsScreen({super.key});

  @override
  State<BenefitsScreen> createState() => _BenefitsScreenState();
}

class _BenefitsScreenState extends State<BenefitsScreen> {
  int selectedTab = 1;

  Future<void> redeem(BuildContext context, CouponModel coupon) async {
    try {
      await AppController.instance.redeem(coupon);
      if (context.mounted) showMessage(context, 'Cupom resgatado com sucesso.');
    } on CouponException catch (error) {
      if (context.mounted) showMessage(context, error.message);
    }
  }

  String _date(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    return '$day/$month/${value.year}';
  }

  IconData _couponIcon(CouponModel coupon) {
    if (coupon.id == 'wash10') return Icons.local_car_wash_rounded;
    if (coupon.id == 'coffee') return Icons.local_cafe_rounded;
    return Icons.oil_barrel_rounded;
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: AppController.instance,
        builder: (_, __) {
          final app = AppController.instance;

          return ListView(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 26),
            children: [
              Row(
                children: [
                  const BrandLogo(size: 72),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GRUPO WK',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: .4,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Confia no Senhor de todo\no seu coração!',
                          style: TextStyle(color: AppColors.muted, height: 1.2),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white54),
                    ),
                    child: const Icon(Icons.person_outline_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              const Text(
                'Benefícios e cupons',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              const Text(
                'Ative vantagens exclusivas para\nusar nos postos WK.',
                style: TextStyle(color: AppColors.muted, fontSize: 16, height: 1.35),
              ),
              const SizedBox(height: 20),
              Container(
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.primary, width: 1),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _BenefitsTabButton(
                        label: 'Promoções',
                        selected: selectedTab == 0,
                        onTap: () => setState(() => selectedTab = 0),
                      ),
                    ),
                    Expanded(
                      child: _BenefitsTabButton(
                        label: 'Cupons',
                        selected: selectedTab == 1,
                        onTap: () => setState(() => selectedTab = 1),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 18, 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF082766), Color(0xFF061A46)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.red, width: 1.3),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Promoções\nexclusivas',
                            style: TextStyle(fontSize: 25, height: 1.0, fontWeight: FontWeight.w900),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Ofertas especiais para quem\nabastece com frequência.',
                            style: TextStyle(fontSize: 14.5, height: 1.3),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Center(
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 118,
                              height: 118,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF06123B),
                                border: Border.all(color: AppColors.primary, width: 4),
                              ),
                            ),
                            Container(
                              width: 92,
                              height: 92,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.red, width: 3),
                              ),
                              child: const Center(
                                child: Text('WK', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                              ),
                            ),
                            const Positioned(
                              right: -4,
                              top: 8,
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: AppColors.primaryDark,
                                child: Icon(Icons.star_rounded, color: Colors.white, size: 22),
                              ),
                            ),
                            const Positioned(
                              left: -7,
                              bottom: 7,
                              child: CircleAvatar(
                                radius: 16,
                                backgroundColor: AppColors.primaryDark,
                                child: Icon(Icons.percent_rounded, color: Colors.white, size: 19),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Text(
                selectedTab == 1 ? 'Cupons disponíveis' : 'Promoções disponíveis',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 12),
              if (selectedTab == 0)
                _PromotionPlaceholder(points: app.points)
              else
                for (final coupon in CouponService.coupons) ...[
                  _CouponBenefitCard(
                    coupon: coupon,
                    icon: _couponIcon(coupon),
                    validUntil: _date(coupon.expiresAt),
                    redeemed: app.isRedeemed(coupon.id),
                    onTap: () => redeem(context, coupon),
                  ),
                  const SizedBox(height: 12),
                ],
            ],
          );
        },
      );
}

class _BenefitsTabButton extends StatelessWidget {
  const _BenefitsTabButton({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(13),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: selected
                  ? const LinearGradient(colors: [Color(0xFF207BFF), Color(0xFF145BFF)])
                  : null,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: selected ? Colors.white : AppColors.muted,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      );
}

class _CouponBenefitCard extends StatelessWidget {
  const _CouponBenefitCard({
    required this.coupon,
    required this.icon,
    required this.validUntil,
    required this.redeemed,
    required this.onTap,
  });

  final CouponModel coupon;
  final IconData icon;
  final String validUntil;
  final bool redeemed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF06152A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF07245D),
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: Container(
                margin: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.red, width: 2),
                ),
                child: Icon(icon, size: 34, color: Colors.white),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coupon.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    coupon.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.muted, fontSize: 12.5, height: 1.25),
                  ),
                  const SizedBox(height: 6),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 12.5),
                      children: [
                        const TextSpan(text: 'Validade: ', style: TextStyle(color: AppColors.primary)),
                        TextSpan(text: validUntil, style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(width: 1, height: 74, color: AppColors.border),
            const SizedBox(width: 10),
            SizedBox(
              width: 98,
              child: FilledButton(
                onPressed: redeemed ? null : onTap,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  redeemed ? 'Ativado' : 'Ativar cupom',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      );
}

class _PromotionPlaceholder extends StatelessWidget {
  const _PromotionPlaceholder({required this.points});
  final int points;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.primaryDark,
              child: Icon(Icons.local_offer_rounded, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                points > 0
                    ? 'Novas promoções serão liberadas conforme suas campanhas e seu saldo de pontos.'
                    : 'As próximas promoções exclusivas aparecerão aqui.',
                style: const TextStyle(color: AppColors.muted, height: 1.35),
              ),
            ),
          ],
        ),
      );
}

'''

text = text[:start] + replacement + text[end:]
path.write_text(text, encoding='utf-8')
