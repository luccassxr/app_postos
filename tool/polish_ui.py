from pathlib import Path

path = Path('lib/main.dart')
text = path.read_text(encoding='utf-8')

# Do NOT extend the Scaffold body behind the fixed points strip. The Scaffold must
# reserve the complete bottom area so the Home can scroll all the way to the end.
text = text.replace('        extendBody: true,\n', '')

# Remove the old large "Seus pontos" card that still exists inside the Home list.
# The only points UI that should remain is the fixed _PointsStrip above NavigationBar.
recent_marker = "              const Text(\n                'Movimentações recentes'"
recent_index = text.find(recent_marker)
if recent_index != -1:
    points_index = text.rfind("const Text('Seus pontos'", 0, recent_index)
    if points_index != -1:
        container_start = text.rfind('              Container(', 0, points_index)
        if container_start != -1:
            # Include the SizedBox immediately before the old card when present.
            remove_start = text.rfind('              const SizedBox(height:', 0, container_start)
            if remove_start == -1 or container_start - remove_start > 90:
                remove_start = container_start

            # Find the matching close of Container(...), counting parentheses.
            open_paren = text.find('(', container_start)
            depth = 0
            end = -1
            in_single = False
            in_double = False
            escaped = False
            for i in range(open_paren, recent_index):
                ch = text[i]
                if escaped:
                    escaped = False
                    continue
                if ch == '\\':
                    escaped = True
                    continue
                if ch == "'" and not in_double:
                    in_single = not in_single
                    continue
                if ch == '"' and not in_single:
                    in_double = not in_double
                    continue
                if in_single or in_double:
                    continue
                if ch == '(':
                    depth += 1
                elif ch == ')':
                    depth -= 1
                    if depth == 0:
                        semi = text.find(';', i, min(i + 8, recent_index))
                        end = semi + 1 if semi != -1 else i + 1
                        break
            if end != -1:
                # Remove trailing spacer after the old card too.
                trailing = text.find('              const SizedBox(height:', end, recent_index)
                if trailing != -1 and trailing - end < 100:
                    trailing_end = text.find('\n', trailing)
                    if trailing_end != -1:
                        end = trailing_end + 1
                text = text[:remove_start] + text[end:]

# Keep comfortable bottom padding in the scrollable Home. Since the Scaffold now
# reserves the fixed strip + NavigationBar, this lets the final section clear them.
text = text.replace(
    'padding: const EdgeInsets.fromLTRB(14, 10, 14, 28),',
    'padding: const EdgeInsets.fromLTRB(14, 10, 14, 44),',
    1,
)
text = text.replace(
    'padding: const EdgeInsets.fromLTRB(14, 10, 14, 20),',
    'padding: const EdgeInsets.fromLTRB(14, 10, 14, 44),',
    1,
)

# Replace the fuel cards with a layout that gives the full price enough width.
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

# Make the benefits/coupons page compact and professional on phones.
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
