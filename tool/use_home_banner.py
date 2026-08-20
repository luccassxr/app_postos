from pathlib import Path

path = Path('lib/main.dart')
text = path.read_text(encoding='utf-8')

old = "child: const _PromoBanner(),"
new = "child: Image.asset(\n                      'assets/images/home_banner.png',\n                      fit: BoxFit.cover,\n                      alignment: Alignment.center,\n                    ),"

if old not in text:
    raise SystemExit('Promo banner placeholder not found')

text = text.replace(old, new)
path.write_text(text, encoding='utf-8')
