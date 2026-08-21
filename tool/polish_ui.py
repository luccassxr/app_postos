from pathlib import Path

path = Path('lib/main.dart')
text = path.read_text(encoding='utf-8')

# Let the Home continue visually behind transparent spacing around the fixed
# points strip. The NavigationBar remains fixed/opaque below it.
main_shell = text.find('class _MainShellState extends State<MainShell> {')
if main_shell != -1:
    scaffold = text.find('Widget build(BuildContext context) => Scaffold(', main_shell)
    if scaffold != -1:
        insert_at = text.find('\n', scaffold) + 1
        if '        extendBody: true,\n' not in text[scaffold:scaffold + 140]:
            text = text[:insert_at] + '        extendBody: true,\n' + text[insert_at:]

# Replace the fuel cards with a layout that gives the full price enough width.
# Title + icon share the first row; price spans the card width underneath.
fuel_start = text.find('class _FuelCard extends StatelessWidget {')
fuel_end = text.find('class _HomeAction', fuel_start)
if fuel_start != -1 and fuel_end != -1:
    fuel_component = r'''class _FuelCard extends StatelessWidget {
  const _FuelCard({
    required this.label,
    required this.price,
    required this.icon,
    required this.accent,
  });

  final String label;
  final String price;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) => Container(
        constraints: const BoxConstraints(minHeight: 108),
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 9),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: accent.withValues(alpha: .55)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: accent,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                CircleAvatar(
                  radius: 14,
                  backgroundColor: accent,
                  child: Icon(icon, color: Colors.white, size: 15),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              price,
              maxLines: 1,
              softWrap: false,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w900,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '/LITRO',
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 11,
                fontWeight: FontWeight.w400,
                height: 1.0,
              ),
            ),
          ],
        ),
      );
}

'''
    text = text[:fuel_start] + fuel_component + text[fuel_end:]
else:
    raise SystemExit('Fuel card markers not found')

# Make the benefits/coupons page more compact and professional on phones.
replacements = {
    'const BrandLogo(size: 72),': 'const BrandLogo(size: 58),',
    'fontSize: 22,\n                            fontWeight: FontWeight.w900,': 'fontSize: 19,\n                            fontWeight: FontWeight.w900,',
    'width: 48,\n                    height: 48,': 'width: 42,\n                    height: 42,',
    'const SizedBox(height: 28),\n              const Text(\n                \'Benefícios e cupons\',\n                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),': 'const SizedBox(height: 20),\n              const Text(\n                \'Benefícios e cupons\',\n                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),',
    'style: TextStyle(color: AppColors.muted, fontSize: 16, height: 1.35),': 'style: TextStyle(color: AppColors.muted, fontSize: 14, height: 1.3),',
    'height: 52,': 'height: 46,',
    'fontSize: 16,\n                color: selected ? Colors.white : AppColors.muted,': 'fontSize: 14,\n                color: selected ? Colors.white : AppColors.muted,',
    'padding: const EdgeInsets.fromLTRB(20, 20, 18, 20),': 'padding: const EdgeInsets.fromLTRB(16, 16, 14, 16),',
    'style: TextStyle(fontSize: 25, height: 1.0, fontWeight: FontWeight.w900),': 'style: TextStyle(fontSize: 21, height: 1.0, fontWeight: FontWeight.w900),',
    'style: TextStyle(fontSize: 14.5, height: 1.3),': 'style: TextStyle(fontSize: 12.5, height: 1.3),',
    'width: 118,\n                              height: 118,': 'width: 96,\n                              height: 96,',
    'width: 92,\n                              height: 92,': 'width: 74,\n                              height: 74,',
    "child: const Center(\n                                child: Text('WK', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),": "child: const Center(\n                                child: Text('WK', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),",
    "style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),": "style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),",
    'padding: const EdgeInsets.all(14),': 'padding: const EdgeInsets.all(11),',
    'width: 72,\n              height: 72,': 'width: 58,\n              height: 58,',
    'child: Icon(icon, size: 34, color: Colors.white),': 'child: Icon(icon, size: 27, color: Colors.white),',
    'const SizedBox(width: 14),': 'const SizedBox(width: 10),',
    'style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),': 'style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900),',
    'style: const TextStyle(color: AppColors.muted, fontSize: 12.5, height: 1.25),': 'style: const TextStyle(color: AppColors.muted, fontSize: 11, height: 1.22),',
    'style: const TextStyle(fontSize: 12.5),': 'style: const TextStyle(fontSize: 11),',
    'Container(width: 1, height: 74, color: AppColors.border),': 'Container(width: 1, height: 62, color: AppColors.border),',
    'width: 98,': 'width: 82,',
    'padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),': 'padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),',
    'style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),': 'style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),',
}
for old, new in replacements.items():
    text = text.replace(old, new)

path.write_text(text, encoding='utf-8')
