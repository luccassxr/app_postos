from pathlib import Path

path = Path('lib/main.dart')
text = path.read_text(encoding='utf-8')

old = "child: const _PromoBanner(),"
new = "child: Transform.scale(\n                      scale: 1.045,\n                      child: Image.asset(\n                        'assets/images/home_banner.png',\n                        fit: BoxFit.cover,\n                        alignment: Alignment.center,\n                      ),\n                    ),"

if old not in text:
    raise SystemExit('Promo banner placeholder not found')

text = text.replace(old, new)

# Remove the temporary Flutter-built promo banner classes so flutter analyze
# does not fail with unused_element after switching to the uploaded asset.
start = text.find('class _PromoBanner extends StatelessWidget {')
end = text.find('class _Dot extends StatelessWidget {')
if start != -1 and end != -1 and end > start:
    text = text[:start] + text[end:]

path.write_text(text, encoding='utf-8')
