import 'package:flutter/material.dart';

/// Centraliza todos os caminhos visuais da marca.
///
/// Para trocar a logo do aplicativo, basta colocar o arquivo em:
/// assets/images/logo_wk.png
/// e manter este caminho abaixo.
class WKBranding {
  static const String mainLogo = 'assets/images/logo_wk.png';
  static const String compactLogo = 'assets/images/logo_wk_compact.png';
}

/// Componente pronto para os locais onde a logo do Grupo WK será exibida.
///
/// Enquanto o arquivo ainda não existir, o app NÃO quebra: ele mostra um
/// espaço marcado para facilitar o trabalho de layout/design.
class WKLogoSlot extends StatelessWidget {
  final double width;
  final double? height;
  final bool compact;
  final BoxFit fit;

  const WKLogoSlot({
    super.key,
    this.width = 180,
    this.height,
    this.compact = false,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    final path = compact ? WKBranding.compactLogo : WKBranding.mainLogo;

    return SizedBox(
      width: width,
      height: height ?? width * .55,
      child: Image.asset(
        path,
        fit: fit,
        errorBuilder: (_, __, ___) => DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFF0A1729),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF2B3C57)),
          ),
          child: const Center(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'LOGO WK\nassets/images/logo_wk.png',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFA7B1C3),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
