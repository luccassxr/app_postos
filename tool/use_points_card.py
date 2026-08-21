from pathlib import Path

path = Path('lib/main.dart')
text = path.read_text(encoding='utf-8')

# Remove any points card accidentally present inside the scrollable Home.
card_call_start = text.find("              _PointsCard(\n                pontosUsuario: app.points,")
if card_call_start != -1:
    block_start = text.rfind("              const SizedBox(height: 18),\n", 0, card_call_start + 1)
    block_end_marker = "              const SizedBox(height: 22),\n"
    block_end = text.find(block_end_marker, card_call_start)
    if block_start != -1 and block_end != -1:
        block_end += len(block_end_marker)
        text = text[:block_start] + text[block_end:]

# The Scaffold reserves the bottomNavigationBar area, but leave some breathing room
# at the end of the Home list so the last content is comfortable to scroll into view.
text = text.replace(
    "padding: const EdgeInsets.fromLTRB(14, 10, 14, 20),",
    "padding: const EdgeInsets.fromLTRB(14, 10, 14, 28),",
    1,
)

# refine_home_details.py creates a temporary simple points bar. Replace it with the
# final compact, code-only points strip, fixed immediately above NavigationBar.
old_bottom = r'''        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: AppController.instance,
              builder: (context, _) {
                final points = AppController.instance.points;
                return InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HistoryScreen()),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF0D2D78), Color(0xFF071A45)],
                      ),
                      border: Border(
                        top: BorderSide(color: AppColors.red, width: 1.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.stars_rounded, color: Colors.white, size: 24),
                        const SizedBox(width: 10),
                        const Text(
                          'Seus pontos',
                          style: TextStyle(color: AppColors.muted, fontSize: 12),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '$points',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                        ),
                        const Spacer(),
                        const Text(
                          'Ver extrato',
                          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_right_rounded, size: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
            NavigationBar(
              selectedIndex: index,
              onDestinationSelected: navigate,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: 'Início',
                ),
                NavigationDestination(
                  icon: Icon(Icons.local_gas_station_outlined),
                  selectedIcon: Icon(Icons.local_gas_station_rounded),
                  label: 'Postos',
                ),
                NavigationDestination(
                  icon: Icon(Icons.star_border_rounded),
                  selectedIcon: Icon(Icons.star_rounded),
                  label: 'Benefícios',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person_rounded),
                  label: 'Perfil',
                ),
              ],
            ),
          ],
        ),'''

new_bottom = r'''        bottomNavigationBar: AnimatedBuilder(
          animation: AppController.instance,
          builder: (context, _) {
            final points = AppController.instance.points;
            return Material(
              color: const Color(0xFF020712),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _PointsStrip(
                      pontosAtuais: points,
                      pontosProximaRecompensa: _nextRewardGoal(points),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const HistoryScreen()),
                      ),
                    ),
                    NavigationBar(
                      selectedIndex: index,
                      onDestinationSelected: navigate,
                      destinations: const [
                        NavigationDestination(
                          icon: Icon(Icons.home_outlined),
                          selectedIcon: Icon(Icons.home_rounded),
                          label: 'Início',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.local_gas_station_outlined),
                          selectedIcon: Icon(Icons.local_gas_station_rounded),
                          label: 'Postos',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.star_border_rounded),
                          selectedIcon: Icon(Icons.star_rounded),
                          label: 'Benefícios',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.person_outline),
                          selectedIcon: Icon(Icons.person_rounded),
                          label: 'Perfil',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),'''

if old_bottom not in text:
    raise SystemExit('Temporary fixed points strip not found')
text = text.replace(old_bottom, new_bottom, 1)

# Remove any older generated points implementation before injecting the final one.
for start_marker in [
    'int _nextBenefitGoal(int pontosUsuario) {',
    'int _nextRewardGoal(int pontosAtuais) {',
]:
    component_start = text.find(start_marker)
    anchor = 'class _Dot extends StatelessWidget {'
    component_end = text.find(anchor)
    if component_start != -1 and component_end != -1 and component_end > component_start:
        text = text[:component_start] + text[component_end:]
        break

component = r'''int _nextRewardGoal(int pontosAtuais) {
  const int faixaRecompensa = 2000;
  final safePoints = pontosAtuais < 0 ? 0 : pontosAtuais;
  return ((safePoints ~/ faixaRecompensa) + 1) * faixaRecompensa;
}

class _PointsStrip extends StatelessWidget {
  const _PointsStrip({
    required this.pontosAtuais,
    required this.pontosProximaRecompensa,
    required this.onTap,
  });

  final int pontosAtuais;
  final int pontosProximaRecompensa;
  final VoidCallback onTap;

  String _formatPoints(int value) {
    final safe = value < 0 ? 0 : value;
    final raw = safe.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < raw.length; i++) {
      if (i > 0 && (raw.length - i) % 3 == 0) buffer.write('.');
      buffer.write(raw[i]);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final safePoints = pontosAtuais < 0 ? 0 : pontosAtuais;
    final pontosRestantes = (pontosProximaRecompensa - safePoints)
        .clamp(0, pontosProximaRecompensa);
    final progresso = pontosProximaRecompensa <= 0
        ? 0.0
        : (safePoints / pontosProximaRecompensa).clamp(0.0, 1.0).toDouble();

    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 86,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF071A38), Color(0xFF06152F)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          border: Border(
            top: BorderSide(color: Color(0xFFE91746), width: 1.4),
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 9, 14, 10),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.primaryDark,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 1.6),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Center(
                            child: Icon(Icons.stars_rounded, color: Colors.white, size: 27),
                          ),
                          Positioned(
                            right: -2,
                            bottom: 1,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: AppColors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Seus pontos',
                            maxLines: 1,
                            style: TextStyle(
                              color: AppColors.muted,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${_formatPoints(safePoints)} pts',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w900,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${_formatPoints(pontosRestantes)} pts para próxima recompensa',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.muted,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w500,
                              height: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white70,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 76,
              right: 42,
              bottom: 5,
              height: 5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(color: const Color(0xFF0A285F)),
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
        ),
      ),
    );
  }
}

'''

anchor = 'class _Dot extends StatelessWidget {'
if anchor not in text:
    raise SystemExit('Widget anchor not found')
text = text.replace(anchor, component + anchor, 1)

path.write_text(text, encoding='utf-8')
