import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const WKClienteApp());
}

class WKClienteApp extends StatelessWidget {
  const WKClienteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WK Cliente',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: WKColors.background,
        colorScheme: const ColorScheme.dark(
          primary: WKColors.blue,
          secondary: WKColors.red,
          surface: WKColors.card,
        ),
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
    );
  }
}

class WKColors {
  static const background = Color(0xFF020817);
  static const background2 = Color(0xFF061329);
  static const card = Color(0xFF081426);
  static const card2 = Color(0xFF0C1B31);
  static const blue = Color(0xFF1264F6);
  static const blue2 = Color(0xFF184EC4);
  static const red = Color(0xFFF41424);
  static const green = Color(0xFF20D96B);
  static const text = Color(0xFFF7F8FB);
  static const muted = Color(0xFFAAB2C3);
  static const border = Color(0xFF31405B);
}

class WKBackground extends StatelessWidget {
  final Widget child;
  const WKBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.25),
          radius: 1.2,
          colors: [Color(0xFF0A285A), WKColors.background, Color(0xFF01040B)],
          stops: [0, .52, 1],
        ),
      ),
      child: child,
    );
  }
}

class WKLogo extends StatelessWidget {
  final double width;
  const WKLogo({super.key, this.width = 190});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(55),
              border: Border.all(color: WKColors.red, width: 5),
              gradient: const LinearGradient(
                colors: [Color(0xFF102F86), Color(0xFF102F86), WKColors.red],
                stops: [0, .58, .58],
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('WK', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, color: Colors.white, height: .9)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text('GRUPO WK', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.1)),
        ],
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WKBackground(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const WKLogo(width: 220),
                const SizedBox(height: 14),
                const Text('Confia no Senhor de todo\no seu coração!', textAlign: TextAlign.center, style: TextStyle(fontSize: 19, fontStyle: FontStyle.italic, color: WKColors.text)),
                const Spacer(),
                const Text('Carregando', style: TextStyle(color: WKColors.muted, fontSize: 17)),
                const SizedBox(height: 14),
                SizedBox(
                  width: 210,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: const LinearProgressIndicator(minHeight: 4, backgroundColor: WKColors.border),
                  ),
                ),
                const SizedBox(height: 70),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final login = TextEditingController();
  final password = TextEditingController();
  bool obscure = true;

  void enter() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainShell()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WKBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(28, 38, 28, 34),
            children: [
              const Center(child: WKLogo(width: 190)),
              const SizedBox(height: 50),
              const Text('Acesse sua conta', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              const Text('Entre para acompanhar seus pontos, benefícios e abastecimentos.', style: TextStyle(color: WKColors.muted, fontSize: 17, height: 1.4)),
              const SizedBox(height: 30),
              WKCard(
                child: Column(
                  children: [
                    WKField(controller: login, hint: 'E-mail ou CPF', icon: Icons.mail_outline),
                    const SizedBox(height: 14),
                    WKField(
                      controller: password,
                      hint: 'Senha',
                      icon: Icons.lock_outline,
                      obscureText: obscure,
                      suffix: IconButton(onPressed: () => setState(() => obscure = !obscure), icon: Icon(obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined)),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Lembrar-me', style: TextStyle(color: WKColors.muted)),
                        TextButton(onPressed: () {}, child: const Text('Esqueci minha senha')),
                      ],
                    ),
                    const SizedBox(height: 8),
                    WKPrimaryButton(label: 'Entrar', onPressed: enter),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                  child: const Text('Ainda não tem conta?  Criar cadastro →'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool accepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: WKBackground(
        child: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(28, 18, 28, 32),
            children: [
              const Center(child: WKLogo(width: 165)),
              const SizedBox(height: 28),
              const Text('Crie sua conta', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              const Text('É rápido, fácil e grátis!', style: TextStyle(color: WKColors.muted, fontSize: 17)),
              const SizedBox(height: 24),
              WKCard(
                child: Column(
                  children: [
                    for (final item in const [
                      ('Nome completo', Icons.person_outline),
                      ('CPF', Icons.badge_outlined),
                      ('Telefone', Icons.phone_outlined),
                      ('E-mail', Icons.mail_outline),
                      ('Senha', Icons.lock_outline),
                      ('Confirmar senha', Icons.lock_outline),
                    ]) ...[
                      WKField(hint: item.$1, icon: item.$2, obscureText: item.$1.contains('Senha') || item.$1.contains('senha')),
                      const SizedBox(height: 12),
                    ],
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: accepted,
                      onChanged: (v) => setState(() => accepted = v ?? false),
                      title: const Text('Li e aceito os termos de uso e política de privacidade.', style: TextStyle(fontSize: 14)),
                    ),
                    const SizedBox(height: 6),
                    WKPrimaryButton(
                      label: 'Criar conta',
                      onPressed: accepted ? () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MainShell()), (_) => false) : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;
  final pages = const [HomeScreen(), StationsScreen(), BenefitsScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WKBackground(child: SafeArea(child: pages[index])),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        backgroundColor: const Color(0xFF041023),
        indicatorColor: const Color(0xFF123B8D),
        onDestinationSelected: (v) => setState(() => index = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Início'),
          NavigationDestination(icon: Icon(Icons.local_gas_station_outlined), selectedIcon: Icon(Icons.local_gas_station), label: 'Postos'),
          NavigationDestination(icon: Icon(Icons.star_outline), selectedIcon: Icon(Icons.star), label: 'Benefícios'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
      children: [
        const Row(
          children: [
            WKLogo(width: 135),
            Spacer(),
            CircleAvatar(radius: 23, backgroundColor: WKColors.card2, child: Icon(Icons.person_outline)),
          ],
        ),
        const SizedBox(height: 25),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: WKColors.red),
            gradient: const LinearGradient(colors: [Color(0xFF0B2D78), Color(0xFF06142C)]),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Abasteça e ganhe pontos', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
              SizedBox(height: 8),
              Text('Mais abastecimentos, mais vantagens para você!', style: TextStyle(color: WKColors.muted, fontSize: 16)),
            ],
          ),
        ),
        const SizedBox(height: 18),
        WKCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Posto mais próximo', style: TextStyle(color: WKColors.blue, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              const Text('Posto WK Ceres', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800)),
              const Text('Ceres - GO • próximo de você', style: TextStyle(color: WKColors.muted)),
              const SizedBox(height: 14),
              WKPrimaryButton(label: 'Ver rota', onPressed: () {}),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const Text('Combustíveis hoje', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        const Row(
          children: [
            Expanded(child: FuelPrice(name: 'GASOLINA', value: 'R\$ 5,69', accent: WKColors.red)),
            SizedBox(width: 10),
            Expanded(child: FuelPrice(name: 'ETANOL', value: 'R\$ 3,89', accent: WKColors.green)),
            SizedBox(width: 10),
            Expanded(child: FuelPrice(name: 'DIESEL S10', value: 'R\$ 5,89', accent: WKColors.blue)),
          ],
        ),
        const SizedBox(height: 18),
        WKCard(
          child: Row(
            children: [
              const CircleAvatar(radius: 30, backgroundColor: Color(0xFF102B68), child: Icon(Icons.stars, color: WKColors.blue, size: 34)),
              const SizedBox(width: 16),
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Seus pontos', style: TextStyle(color: WKColors.muted)), Text('1.250', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900))])),
              TextButton(onPressed: () {}, child: const Text('Ver extrato')),
            ],
          ),
        ),
      ],
    );
  }
}

class FuelPrice extends StatelessWidget {
  final String name;
  final String value;
  final Color accent;
  const FuelPrice({super.key, required this.name, required this.value, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: WKColors.card2, borderRadius: BorderRadius.circular(16), border: Border.all(color: accent.withOpacity(.5))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: TextStyle(color: accent, fontSize: 12, fontWeight: FontWeight.w800)), const SizedBox(height: 8), Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)), const Text('/LITRO', style: TextStyle(color: WKColors.muted, fontSize: 11))]),
    );
  }
}

class BenefitsScreen extends StatelessWidget {
  const BenefitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final coupons = const [
      ('10% OFF na lavagem', 'Desconto especial para deixar seu veículo impecável.', '30/09/2026', Icons.local_car_wash),
      ('Café grátis', 'Ganhe 1 café em abastecimentos acima de R\$ 80.', '15/10/2026', Icons.coffee_outlined),
      ('Troca de óleo com desconto', 'Benefício exclusivo em serviços selecionados.', '25/10/2026', Icons.oil_barrel_outlined),
    ];
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
      children: [
        const Text('Benefícios e cupons', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
        const SizedBox(height: 5),
        const Text('Ative vantagens exclusivas para usar nos postos WK.', style: TextStyle(color: WKColors.muted)),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: WKColors.red), gradient: const LinearGradient(colors: [Color(0xFF0D2A6A), Color(0xFF07142B)])),
          child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Promoções exclusivas', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)), SizedBox(height: 6), Text('Ofertas especiais para clientes WK.', style: TextStyle(color: WKColors.muted))]),
        ),
        const SizedBox(height: 22),
        const Text('Cupons disponíveis', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        for (final c in coupons) ...[
          WKCard(
            child: Row(
              children: [
                CircleAvatar(radius: 25, backgroundColor: const Color(0xFF102B68), child: Icon(c.$4, color: WKColors.blue)),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(c.$1, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)), const SizedBox(height: 4), Text(c.$2, style: const TextStyle(color: WKColors.muted, fontSize: 13)), const SizedBox(height: 7), Text('Validade: ${c.$3}', style: const TextStyle(color: WKColors.blue, fontSize: 13))])),
                const SizedBox(width: 8),
                FilledButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${c.$1} ativado!'))), child: const Text('Ativar')),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 10),
        OutlinedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PromotionsScreen())), icon: const Icon(Icons.local_offer_outlined), label: const Text('Ver promoções em lojas WK')),
      ],
    );
  }
}

class PromotionsScreen extends StatelessWidget {
  const PromotionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final promos = const [
      ('WK Acessórios • Querência - MT', 'Combo de limpeza automotiva', 'Shampoo + silicone + pano de microfibra com preço especial.'),
      ('WK Acessórios • Rio Verde - GO', 'Aromatizantes em dobro', 'Leve 2 aromatizantes selecionados e pague menos.'),
      ('WK Acessórios • Querência - MT', 'Troca de óleo com desconto', 'Desconto especial em lubrificantes e acessórios automotivos.'),
      ('WK Acessórios • Rio Verde - GO', 'Kit viagem WK', 'Acessórios selecionados com preço promocional.'),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Promoções'), backgroundColor: WKColors.background),
      body: WKBackground(
        child: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            const Text('Ofertas em lojas WK Acessórios', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
            const SizedBox(height: 18),
            for (final p in promos) ...[
              WKCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(p.$1, style: const TextStyle(color: WKColors.blue, fontWeight: FontWeight.w700)), const SizedBox(height: 7), Text(p.$2, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)), const SizedBox(height: 5), Text(p.$3, style: const TextStyle(color: WKColors.muted)), const SizedBox(height: 12), WKPrimaryButton(label: 'Ver oferta', onPressed: () {})])),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

class StationsScreen extends StatelessWidget {
  const StationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stations = const [
      ('Posto WK Ceres', 'Ceres - GO', '0 km', 'Conveniência • Café • Lavagem • Diesel'),
      ('Posto WK Jaraguá', 'Jaraguá - GO', '61 km', 'Conveniência • Troca de óleo • Diesel'),
      ('Posto WK Anápolis', 'Anápolis - GO', '141 km', 'Conveniência • Café • Banheiros'),
      ('Posto WK Rio Verde', 'Rio Verde - GO', '407 km', 'Conveniência • WK Acessórios • Lavagem'),
      ('Posto WK Jataí', 'Jataí - GO', '496 km', 'Conveniência • Diesel • Troca de óleo'),
      ('Posto WK Querência', 'Querência - MT', '577 km', 'Conveniência • WK Acessórios • Diesel'),
    ];
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
      children: [
        const Text('Postos', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
        const SizedBox(height: 5),
        const Text('Base de busca: Ceres - GO', style: TextStyle(color: WKColors.muted)),
        const SizedBox(height: 18),
        const WKField(hint: 'Buscar posto ou cidade', icon: Icons.search),
        const SizedBox(height: 16),
        for (final s in stations) ...[
          WKCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(radius: 28, backgroundColor: Color(0xFF102B68), child: Icon(Icons.local_gas_station, color: WKColors.blue)),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(s.$1, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)), Text(s.$2, style: const TextStyle(color: WKColors.muted)), const SizedBox(height: 6), Text(s.$4, style: const TextStyle(color: WKColors.muted, fontSize: 12))])),
                Text(s.$3, style: const TextStyle(fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = const [
      ('Posto WK Rio Verde', 'Gasolina Comum', 'R\$ 250,00', '+125'),
      ('Posto WK Querência', 'Diesel S10', 'R\$ 420,00', '+210'),
      ('Posto WK Ceres', 'Etanol', 'R\$ 180,00', '+90'),
    ];
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
      children: [
        const Text('Perfil e Histórico', style: TextStyle(fontSize: 29, fontWeight: FontWeight.w900)),
        const SizedBox(height: 16),
        WKCard(
          child: const Row(
            children: [
              CircleAvatar(radius: 34, backgroundColor: Color(0xFF102B68), child: Icon(Icons.person, size: 38, color: WKColors.blue)),
              SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Lucas Araújo', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)), Text('Cliente WK Premium', style: TextStyle(color: WKColors.blue)), SizedBox(height: 8), Text('lucas@email.com • Rio Verde - GO', style: TextStyle(color: WKColors.muted, fontSize: 13))])),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Row(children: [Expanded(child: MiniStat(label: 'Pontos', value: '3.450')), SizedBox(width: 8), Expanded(child: MiniStat(label: 'Cupons', value: '12')), SizedBox(width: 8), Expanded(child: MiniStat(label: 'Abastecimentos', value: '18'))]),
        const SizedBox(height: 24),
        const Text('Histórico de abastecimentos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        for (final h in history) ...[
          WKCard(child: Row(children: [const Icon(Icons.local_gas_station, color: WKColors.blue), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(h.$1, style: const TextStyle(fontWeight: FontWeight.w800)), Text('${h.$2} • ${h.$3}', style: const TextStyle(color: WKColors.muted, fontSize: 13))])), Text('${h.$4} pts', style: const TextStyle(color: WKColors.blue, fontWeight: FontWeight.w800))])),
          const SizedBox(height: 9),
        ],
        const SizedBox(height: 14),
        OutlinedButton.icon(
          onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false),
          icon: const Icon(Icons.logout),
          label: const Text('Sair da conta'),
        ),
      ],
    );
  }
}

class MiniStat extends StatelessWidget {
  final String label;
  final String value;
  const MiniStat({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: WKColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: WKColors.border)),
      child: Column(children: [Text(label, textAlign: TextAlign.center, style: const TextStyle(color: WKColors.muted, fontSize: 11)), const SizedBox(height: 5), Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 19))]),
    );
  }
}

class WKCard extends StatelessWidget {
  final Widget child;
  const WKCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: WKColors.card.withOpacity(.92),
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: WKColors.border),
        boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 18, offset: Offset(0, 8))],
      ),
      child: child,
    );
  }
}

class WKField extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final Widget? suffix;
  const WKField({super.key, this.controller, required this.hint, required this.icon, this.obscureText = false, this.suffix});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF7F899A)),
        prefixIcon: Icon(icon, color: WKColors.muted),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0x660A162A),
        contentPadding: const EdgeInsets.symmetric(vertical: 19, horizontal: 16),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: WKColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: WKColors.blue, width: 1.4)),
      ),
    );
  }
}

class WKPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  const WKPrimaryButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: WKColors.blue,
          disabledBackgroundColor: const Color(0xFF18335E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(label, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
      ),
    );
  }
}
