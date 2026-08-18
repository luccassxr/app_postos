# Logos do aplicativo

Coloque aqui os arquivos de identidade visual do Grupo WK.

Arquivos esperados pelo componente `WKLogoSlot`:

- `logo_wk.png` — logo principal, de preferência PNG com fundo transparente.
- `logo_wk_compact.png` — versão compacta opcional para cabeçalhos pequenos.

Se você não tiver uma versão compacta, pode usar a mesma imagem nos dois arquivos.

Recomendação:

- PNG com transparência.
- Boa resolução, por exemplo 1000 px ou mais de largura para a logo principal.
- Não deixe margens transparentes enormes em volta da arte.

Depois de adicionar os arquivos, rode:

```bash
flutter pub get
flutter run -t lib/main_functional.dart
```

O código que centraliza os caminhos está em `lib/branding.dart`.
