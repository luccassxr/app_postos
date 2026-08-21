from pathlib import Path

path = Path('lib/main.dart')
text = path.read_text(encoding='utf-8')

# Never let the Home extend behind the fixed points strip/navigation.
text = text.replace('        extendBody: true,\n', '')

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

# Give the final Home content extra breathing room above the fixed strip.
text = text.replace(
    'padding: const EdgeInsets.fromLTRB(14, 10, 14, 28),',
    'padding: const EdgeInsets.fromLTRB(14, 10, 14, 48),',
    1,
)
text = text.replace(
    'padding: const EdgeInsets.fromLTRB(14, 10, 14, 44),',
    'padding: const EdgeInsets.fromLTRB(14, 10, 14, 48),',
    1,
)

path.write_text(text, encoding='utf-8')
