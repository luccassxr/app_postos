from pathlib import Path

path = Path('lib/main.dart')
text = path.read_text(encoding='utf-8')

text = text.replace('scale: 1.045,', 'scale: 1.085,')
text = text.replace("'Posto em destaque'", "'Posto mais próximo'")
text = text.replace(
    'style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, height: 1.0),',
    'style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, height: 1.0),',
)

# Keep the fuel value at the requested 18px bold size without FittedBox,
# so the typography stays consistent instead of being visually compressed.
old_fitted_price = '''                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          price,
                          maxLines: 1,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, height: 1.0),
                        ),
                      ),'''
normal_price = '''                      Text(
                        price,
                        maxLines: 1,
                        overflow: TextOverflow.visible,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, height: 1.0),
                      ),'''
text = text.replace(old_fitted_price, normal_price)

# Remove the large points card from inside the Home scroll. The points balance
# remains available only in the fixed bar above the bottom navigation.
points_marker = "const Text('Seus pontos', style: TextStyle(color: AppColors.muted))"
marker_index = text.find(points_marker)
if marker_index != -1:
    block_start = text.rfind('              const SizedBox(height: 22),\n              Container(', 0, marker_index)
    next_section = text.find("              const Text(\n                'Movimentações recentes'", marker_index)
    if block_start != -1 and next_section != -1:
        text = text[:block_start] + text[next_section:]

old_nav = '''        bottomNavigationBar: NavigationBar(
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
        ),'''

new_nav = '''        bottomNavigationBar: Column(
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

if old_nav not in text:
    raise SystemExit('Bottom navigation block not found')

text = text.replace(old_nav, new_nav)
path.write_text(text, encoding='utf-8')
