from pathlib import Path

path = Path('lib/main.dart')
text = path.read_text(encoding='utf-8')

# Remove any leftover syntax fragment created while deleting the old Home points card.
text = text.replace(
    "              ),\n              const Text(\n                'Movimentações recentes'",
    "              const Text(\n                'Movimentações recentes'",
    1,
)

# If the old large points card is still present in the scrollable Home, remove the
# whole section safely by cutting from the spacer before it up to the recent-moves title.
recent_marker = "              const Text(\n                'Movimentações recentes'"
recent_index = text.find(recent_marker)
if recent_index != -1:
    points_index = text.rfind("const Text('Seus pontos'", 0, recent_index)
    if points_index != -1:
        remove_start = text.rfind('              const SizedBox(height:', 0, points_index)
        if remove_start != -1:
            text = text[:remove_start] + text[recent_index:]

# The points strip used to live inside bottomNavigationBar, forcing Flutter to reserve
# a large opaque rectangle behind it. Move the strip into a transparent overlay over
# the Home body, while keeping only NavigationBar in bottomNavigationBar.
old_shell = r'''  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          bottom: false,
          child: IndexedStack(
            index: index,
            children: [
              HomeScreen(onNavigate: navigate),
              const StationsScreen(),
              const BenefitsScreen(),
              const ProfileScreen(),
            ],
          ),
        ),
        bottomNavigationBar: AnimatedBuilder(
          animation: AppController.instance,
          builder: (context, _) {
            final points = AppController.instance.points;
            return SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
                    child: _PointsStrip(
                      pontosAtuais: points,
                      pontosProximaRecompensa: _nextRewardGoal(points),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const HistoryScreen()),
                      ),
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
            );
          },
        ),
      );'''

new_shell = r'''  @override
  Widget build(BuildContext context) => Scaffold(
        extendBody: true,
        body: Stack(
          children: [
            SafeArea(
              bottom: false,
              child: IndexedStack(
                index: index,
                children: [
                  HomeScreen(onNavigate: navigate),
                  const StationsScreen(),
                  const BenefitsScreen(),
                  const ProfileScreen(),
                ],
              ),
            ),
            if (index == 0)
              Positioned(
                left: 12,
                right: 12,
                bottom: 92,
                child: AnimatedBuilder(
                  animation: AppController.instance,
                  builder: (context, _) {
                    final points = AppController.instance.points;
                    return _PointsStrip(
                      pontosAtuais: points,
                      pontosProximaRecompensa: _nextRewardGoal(points),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const HistoryScreen()),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
        bottomNavigationBar: NavigationBar(
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
      );'''

if old_shell not in text:
    raise SystemExit('Fixed points/navigation shell not found')
text = text.replace(old_shell, new_shell, 1)

# Because the strip now floats over the Home, give the scrollable Home enough bottom
# space to bring its last card fully above the overlay instead of hiding behind it.
for current in [
    'padding: const EdgeInsets.fromLTRB(14, 10, 14, 28),',
    'padding: const EdgeInsets.fromLTRB(14, 10, 14, 44),',
    'padding: const EdgeInsets.fromLTRB(14, 10, 14, 48),',
]:
    text = text.replace(
        current,
        'padding: const EdgeInsets.fromLTRB(14, 10, 14, 150),',
        1,
    )

path.write_text(text, encoding='utf-8')
