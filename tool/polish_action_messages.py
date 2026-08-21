from pathlib import Path

path = Path('lib/main.dart')
text = path.read_text(encoding='utf-8')

old = """void showMessage(BuildContext context, String text) =>\n    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));"""

new = """void showMessage(BuildContext context, String text) {\n  final messenger = ScaffoldMessenger.of(context);\n  messenger.hideCurrentSnackBar();\n  messenger.showSnackBar(\n    SnackBar(\n      content: Text(\n        text,\n        maxLines: 2,\n        overflow: TextOverflow.ellipsis,\n        textAlign: TextAlign.center,\n        style: const TextStyle(\n          color: Colors.white,\n          fontSize: 12.5,\n          fontWeight: FontWeight.w600,\n        ),\n      ),\n      behavior: SnackBarBehavior.floating,\n      duration: const Duration(milliseconds: 1600),\n      elevation: 2,\n      backgroundColor: const Color(0xFF102A55),\n      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),\n      margin: const EdgeInsets.fromLTRB(44, 0, 44, 12),\n      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),\n    ),\n  );\n}"""

if old not in text:
    raise SystemExit('showMessage helper not found')

text = text.replace(old, new, 1)
path.write_text(text, encoding='utf-8')
