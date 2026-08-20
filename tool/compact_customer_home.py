from pathlib import Path

path = Path('lib/main.dart')
text = path.read_text(encoding='utf-8')

replacements = {
    "padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),": "padding: const EdgeInsets.fromLTRB(14, 10, 14, 20),",
    "const BrandLogo(size: 66),": "const BrandLogo(size: 56),",
    "const SizedBox(width: 13),": "const SizedBox(width: 10),",
    "fontSize: 23,": "fontSize: 20,",
    "radius: 22,": "radius: 19,",
    "const SizedBox(height: 20),\n              InkWell(\n                borderRadius: BorderRadius.circular(18),": "const SizedBox(height: 14),\n              InkWell(\n                borderRadius: BorderRadius.circular(16),",
    "borderRadius: BorderRadius.circular(18),\n                  child: AspectRatio(\n                    aspectRatio: 2.34,": "borderRadius: BorderRadius.circular(16),\n                  child: AspectRatio(\n                    aspectRatio: 2.60,",
    "child: Image.asset(\n                      'assets/images/banner_abasteca_pontos.jpg',\n                      fit: BoxFit.cover,\n                    ),": "child: const _PromoBanner(),",
    "const SizedBox(height: 18),\n              Container(\n                padding: const EdgeInsets.all(16),": "const SizedBox(height: 14),\n              Container(\n                padding: const EdgeInsets.all(13),",
    "borderRadius: BorderRadius.circular(20),": "borderRadius: BorderRadius.circular(18),",
    "width: 62,\n                      height: 62,": "width: 52,\n                      height: 52,",
    "child: const Icon(Icons.local_gas_station_rounded, size: 32),": "child: const Icon(Icons.local_gas_station_rounded, size: 27),",
    "const SizedBox(width: 14),": "const SizedBox(width: 11),",
    "Icon(Icons.location_on_rounded, color: AppColors.primary, size: 18),": "Icon(Icons.location_on_rounded, color: AppColors.primary, size: 16),",
    "style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),": "style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w700),",
    "style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),": "style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),",
    "Text(station.location, style: const TextStyle(color: AppColors.muted)),": "Text(station.location, style: const TextStyle(color: AppColors.muted, fontSize: 12)),",
    "const SizedBox(height: 22),\n              const Row(\n                children: [\n                  Icon(Icons.local_gas_station_rounded),": "const SizedBox(height: 18),\n              const Row(\n                children: [\n                  Icon(Icons.local_gas_station_rounded, size: 20),",
    "Text('Combustíveis', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),": "Text('Combustíveis', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),",
    "Expanded(child: _FuelCard(label: 'GASOLINA', icon: Icons.local_fire_department_rounded, accent: AppColors.danger)),": "Expanded(child: _FuelCard(label: 'GASOLINA', price: 'R\\$ 5,69', icon: Icons.local_fire_department_rounded, accent: AppColors.danger)),",
    "Expanded(child: _FuelCard(label: 'ETANOL', icon: Icons.water_drop_rounded, accent: AppColors.success)),": "Expanded(child: _FuelCard(label: 'ETANOL', price: 'R\\$ 3,89', icon: Icons.water_drop_rounded, accent: AppColors.success)),",
    "Expanded(child: _FuelCard(label: 'DIESEL S10', icon: Icons.opacity_rounded, accent: AppColors.primary)),": "Expanded(child: _FuelCard(label: 'DIESEL S10', price: 'R\\$ 5,89', icon: Icons.opacity_rounded, accent: AppColors.primary)),",
    "const SizedBox(height: 24),\n              GridView.count(": "const SizedBox(height: 18),\n              GridView.count(",
    "mainAxisSpacing: 18,": "mainAxisSpacing: 12,",
    "crossAxisSpacing: 10,": "crossAxisSpacing: 8,",
    "childAspectRatio: .95,": "childAspectRatio: 1.08,",
    "const _FuelCard({required this.label, required this.icon, required this.accent});\n  final String label;": "const _FuelCard({required this.label, required this.price, required this.icon, required this.accent});\n  final String label;\n  final String price;",
    "padding: const EdgeInsets.all(12),": "padding: const EdgeInsets.all(10),",
    "Text(label, style: TextStyle(color: accent, fontSize: 12, fontWeight: FontWeight.w800)),\n            const SizedBox(height: 10),": "Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: accent, fontSize: 10.5, fontWeight: FontWeight.w800)),\n            const SizedBox(height: 7),",
    "'Consulte\\nno posto',\n                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, height: 1.15),": "'$price\\n/LITRO',\n                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, height: 1.12),",
    "radius: 18,\n                  backgroundColor: accent,\n                  child: Icon(icon, color: Colors.white, size: 19),": "radius: 15,\n                  backgroundColor: accent,\n                  child: Icon(icon, color: Colors.white, size: 16),",
    "width: 66,\n              height: 66,": "width: 56,\n              height: 56,",
    "child: Icon(icon, color: Colors.white, size: 31),": "child: Icon(icon, color: Colors.white, size: 26),",
    "const SizedBox(height: 9),\n            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),": "const SizedBox(height: 7),\n            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),",
}

for old, new in replacements.items():
    if old in text:
        text = text.replace(old, new)

if 'class _PromoBanner extends StatelessWidget' not in text:
    anchor = 'class _Dot extends StatelessWidget {'
    banner = '''class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0B2D78), Color(0xFF06173E)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.red, width: 1.4),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Expanded(
              flex: 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Abasteça e\nganhe pontos',
                    style: TextStyle(fontSize: 22, height: 1.0, fontWeight: FontWeight.w900),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Mais abastecimentos,\nmais vantagens para você!',
                    style: TextStyle(fontSize: 12.5, height: 1.2),
                  ),
                  SizedBox(height: 10),
                  _PromoButton(),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.fromBorderSide(BorderSide(color: AppColors.primary, width: 5)),
                      boxShadow: [
                        BoxShadow(color: Color(0x55FF1830), spreadRadius: 7, blurRadius: 0),
                      ],
                    ),
                  ),
                  Icon(Icons.local_gas_station_rounded, size: 74, color: AppColors.primary),
                ],
              ),
            ),
          ],
        ),
      );
}

class _PromoButton extends StatelessWidget {
  const _PromoButton();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: AppColors.red, width: 1.2),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Ver benefícios', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
            SizedBox(width: 6),
            Icon(Icons.chevron_right_rounded, size: 18),
          ],
        ),
      );
}

'''
    text = text.replace(anchor, banner + anchor)

path.write_text(text, encoding='utf-8')
