from pathlib import Path

path = Path('lib/main.dart')
text = path.read_text(encoding='utf-8')

if 'class _PointsCard extends StatelessWidget' not in text:
    marker = "              const Text(\n                'Movimentações recentes',"
    card_call = r'''              const SizedBox(height: 18),
              _PointsCard(
                pontosUsuario: app.points,
                metaProximoBeneficio: _nextBenefitGoal(app.points),
                onViewStatement: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HistoryScreen()),
                ),
              ),
              const SizedBox(height: 22),
'''
    if marker not in text:
        raise SystemExit('Recent movements section not found')
    text = text.replace(marker, card_call + marker, 1)

    anchor = 'class _Dot extends StatelessWidget {'
    component = r'''int _nextBenefitGoal(int pontosUsuario) {
  const int faixaBeneficio = 2000;
  final safePoints = pontosUsuario < 0 ? 0 : pontosUsuario;
  return ((safePoints ~/ faixaBeneficio) + 1) * faixaBeneficio;
}

class _PointsCard extends StatelessWidget {
  const _PointsCard({
    required this.pontosUsuario,
    required this.metaProximoBeneficio,
    required this.onViewStatement,
  });

  final int pontosUsuario;
  final int metaProximoBeneficio;
  final VoidCallback onViewStatement;

  String _formatPoints(int value) {
    final raw = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < raw.length; i++) {
      if (i > 0 && (raw.length - i) % 3 == 0) buffer.write('.');
      buffer.write(raw[i]);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final faltantes = metaProximoBeneficio > pontosUsuario
        ? metaProximoBeneficio - pontosUsuario
        : 0;
    final progresso = metaProximoBeneficio <= 0
        ? 0.0
        : (pontosUsuario / metaProximoBeneficio).clamp(0.0, 1.0).toDouble();

    return AspectRatio(
      aspectRatio: 1600 / 704,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;
            return Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/points_card_base.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFF06143A),
                  ),
                ),
                Positioned(
                  left: w * .27,
                  top: h * .18,
                  width: w * .38,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Seus pontos',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: h * .015),
                      Text(
                        _formatPoints(pontosUsuario),
                        maxLines: 1,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          height: 1.0,
                        ),
                      ),
                      SizedBox(height: h * .035),
                      Text(
                        'Faltam ${_formatPoints(faltantes)} pontos para o próximo benefício!',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: w * .675,
                  top: h * .14,
                  width: w * .27,
                  height: h * .23,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: onViewStatement,
                      child: const Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Ver extrato',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.chevron_right_rounded, size: 18, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: w * .27,
                  right: w * .145,
                  bottom: h * .095,
                  height: h * .055,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(color: const Color(0xFF092B78)),
                        FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: progresso,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFFE91746),
                              borderRadius: BorderRadius.all(Radius.circular(999)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

'''
    if anchor not in text:
        raise SystemExit('Widget anchor not found')
    text = text.replace(anchor, component + anchor, 1)

path.write_text(text, encoding='utf-8')
