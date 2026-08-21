from pathlib import Path

path = Path('lib/main.dart')
text = path.read_text(encoding='utf-8')

text = text.replace('scale: 1.045,', 'scale: 1.085,')
text = text.replace("'Posto em destaque'", "'Posto mais próximo'")

# Keep fuel prices visible but larger and easier to read.
text = text.replace(
    'style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, height: 1.0),',
    'style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, height: 1.0),',
)
text = text.replace(
    'style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, height: 1.0),',
    'style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, height: 1.0),',
)
text = text.replace(
    "fontSize: 10.5, fontWeight: FontWeight.w400, height: 1.0",
    "fontSize: 11.5, fontWeight: FontWeight.w400, height: 1.0",
)
text = text.replace(
    "fontSize: 10.5, fontWeight: FontWeight.w800",
    "fontSize: 11.5, fontWeight: FontWeight.w800",
)
text = text.replace(
    "radius: 15,\n                  backgroundColor: accent,\n                  child: Icon(icon, color: Colors.white, size: 16),",
    "radius: 17,\n                  backgroundColor: accent,\n                  child: Icon(icon, color: Colors.white, size: 18),",
)

# Upgrade the fuel section header and show a temporary update timestamp.
# This label is display-only for now and can later be fed by WK Frentista/Firestore.
old_header = '''              const Row(
                children: [
                  Icon(Icons.local_gas_station_rounded, size: 20),
                  SizedBox(width: 8),
                  Text('Combustíveis', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                ],
              ),'''
new_header = '''              const Row(
                children: [
                  Icon(Icons.local_gas_station_rounded, size: 21),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Combustíveis hoje',
                      style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
                    ),
                  ),
                  Text(
                    'Atualizado 21/08 às 14:19',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),'''
text = text.replace(old_header, new_header)

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
