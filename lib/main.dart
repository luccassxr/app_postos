import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(const WKClienteApp());

class WKColors {
  static const bg = Color(0xFF020712);
  static const bg2 = Color(0xFF07162D);
  static const card = Color(0xFF091629);
  static const card2 = Color(0xFF0D1D34);
  static const blue = Color(0xFF1768FF);
  static const blueDark = Color(0xFF0E3E99);
  static const red = Color(0xFFFF1830);
  static const green = Color(0xFF25D87A);
  static const text = Color(0xFFF7F9FF);
  static const muted = Color(0xFFA7B1C3);
  static const border = Color(0xFF2A3D5C);
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
        scaffoldBackgroundColor: WKColors.bg,
        colorScheme: const ColorScheme.dark(
          primary: WKColors.blue,
          secondary: WKColors.red,
          surface: WKColors.card,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: WKColors.card2,
          hintStyle: const TextStyle(color: WKColors.muted),
          prefixIconColor: WKColors.muted,
          suffixIconColor: WKColors.muted,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: WKColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: WKColors.blue, width: 1.5),
          ),
        ),
      ),
      home: const SplashPage(),
    );
  }
}

class WKBackdrop extends StatelessWidget {
  final Widget child;
  const WKBackdrop({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.52),
          radius: 1.25,
          colors: [Color(0xFF0B2D62), WKColors.bg2, WKColors.bg, Color(0xFF000308)],
          stops: [0, .34, .73, 1],
        ),
      ),
      child: child,
    );
  }
}

class WKLogo extends StatelessWidget {
  final double width;
  final bool slogan;
  const WKLogo({super.key, this.width = 170, this.slogan = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/wk_logo.webp',
            width: width,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
            errorBuilder: (_, __, ___) => Container(
              width: width,
              height: width * .48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: WKColors.red, width: 2),
                borderRadius: BorderRadius.circular(18),
                color: WKColors.card2,
              ),
              child: const Text('GRUPO WK', style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          ),
          if (slogan) ...[
            const SizedBox(height: 7),
            const Text(
              'Confia no Senhor de todo\no seu coração!',
              textAlign: TextAlign.center,
              style: TextStyle(color: WKColors.text, fontStyle: FontStyle.italic, height: 1.25),
            ),
          ],
        ],
      ),
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1700), () {
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WKBackdrop(
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              const WKLogo(width: 230, slogan: true),
              const Spacer(),
              const Text('Carregando', style: TextStyle(color: WKColors.muted, fontSize: 15)),
              const SizedBox(height: 12),
              SizedBox(
                width: 190,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: const LinearProgressIndicator(
                    minHeight: 4,
                    backgroundColor: WKColors.border,
                    valueColor: AlwaysStoppedAnimation(WKColors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final login = TextEditingController();
  final password = TextEditingController();
  bool hide = true;
  bool loading = false;

  Future<void> enter() async {
    setState(() => loading = true);
    await Future.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainShell()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WKBackdrop(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
            children: [
              const Center(child: WKLogo(width: 180, slogan: true)),
              const SizedBox(height: 34),
              const Text('Acesse sua conta', style: TextStyle(fontSize: 31, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              const Text(
                'Entre para acompanhar pontos, benefícios e abastecimentos.',
                style: TextStyle(color: WKColors.muted, fontSize: 16, height: 1.4),
              ),
              const SizedBox(height: 24),
              WKCard(
                child: Column(
                  children: [
                    TextField(
                      controller: login,
                      decoration: const InputDecoration(
                        hintText: 'E-mail ou CPF',
                        prefixIcon: Icon(Icons.person_outline_rounded),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: password,
                      obscureText: hide,
                      decoration: InputDecoration(
                        hintText: 'Senha',
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => hide = !hide),
                          icon: Icon(hide ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => toast(context, 'Recuperação de senha será conectada ao Firebase.'),
                        child: const Text('Esqueci minha senha'),
                      ),
                    ),
                    PrimaryButton(label: loading ? 'ENTRANDO...' : 'ENTRAR', onTap: loading ? null : enter),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage())),
                  child: const Text('Ainda não tem conta?  Criar cadastro'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool accepted = false;

  @override
  Widget build(BuildContext context) {
    const fields = [
      ('Nome completo', Icons.person_outline),
      ('CPF', Icons.badge_outlined),
      ('Telefone', Icons.phone_outlined),
      ('E-mail', Icons.mail_outline),
      ('Senha', Icons.lock_outline),
      ('Confirmar senha', Icons.lock_outline),
    ];

    return Scaffold(
      body: WKBackdrop(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 14, 22, 32),
            children: [
              Row(
                children: [
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_rounded)),
                  const Spacer(),
                  const WKLogo(width: 120),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Crie sua conta', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              const Text('É rápido, fácil e grátis!', style: TextStyle(color: WKColors.muted)),
              const SizedBox(height: 18),
              WKCard(
                child: Column(
                  children: [
                    for (final f in fields) ...[
                      TextField(
                        obscureText: f.$1.toLowerCase().contains('senha'),
                        decoration: InputDecoration(hintText: f.$1, prefixIcon: Icon(f.$2)),
                      ),
                      const SizedBox(height: 12),
                    ],
                    CheckboxListTile(
                      value: accepted,
                      onChanged: (v) => setState(() => accepted = v ?? false),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text(
                        'Li e aceito os termos de uso e a política de privacidade.',
                        style: TextStyle(fontSize: 13.5),
                      ),
                    ),
                    PrimaryButton(
                      label: 'CRIAR CONTA',
                      onTap: accepted
                          ? () => Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => const MainShell()),
                                (_) => false,
                              )
                          : null,
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
  final pages = const [HomePage(), StationsPage(), BenefitsPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WKBackdrop(child: SafeArea(child: pages[index])),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        height: 72,
        backgroundColor: const Color(0xFF030C1B),
        indicatorColor: const Color(0xFF123A83),
        onDestinationSelected: (v) => setState(() => index = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Início'),
          NavigationDestination(icon: Icon(Icons.local_gas_station_outlined), selectedIcon: Icon(Icons.local_gas_station_rounded), label: 'Postos'),
          NavigationDestination(icon: Icon(Icons.star_outline), selectedIcon: Icon(Icons.star_rounded), label: 'Benefícios'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person_rounded), label: 'Perfil'),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 390;
    final pad = compact ? 14.0 : 18.0;

    return ListView(
      padding: EdgeInsets.fromLTRB(pad, 14, pad, 24),
      children: [
        Row(
          children: [
            WKLogo(width: compact ? 88 : 104),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('GRUPO WK', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                  SizedBox(height: 2),
                  Text(
                    'Confia no Senhor de todo o seu coração!',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: WKColors.muted, fontSize: 11.5, height: 1.2),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Column(
              children: [
                CircleAvatar(
                  radius: 21,
                  backgroundColor: WKColors.card2,
                  child: Icon(Icons.person_outline_rounded),
                ),
                SizedBox(height: 4),
                Text('Olá, Cliente!', style: TextStyle(fontSize: 10.5)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 18),
        Container(
          padding: EdgeInsets.all(compact ? 16 : 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: WKColors.red, width: 1.5),
            gradient: const LinearGradient(colors: [Color(0xFF0C347D), Color(0xFF07142B)]),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Abasteça e\nganhe pontos',
                      style: TextStyle(fontSize: compact ? 24 : 28, fontWeight: FontWeight.w900, height: 1.04),
                    ),
                    const SizedBox(height: 10),
                    const Text('Mais abastecimentos, mais vantagens para você!', style: TextStyle(height: 1.35)),
                    const SizedBox(height: 14),
                    OutlinedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BenefitsPage())),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: WKColors.red),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                      ),
                      child: const Text('Ver benefícios  ›'),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: compact ? 82 : 104,
                height: compact ? 82 : 104,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF102F77),
                  border: Border.all(color: WKColors.red, width: 2),
                ),
                child: Icon(Icons.local_gas_station_rounded, color: Colors.white, size: compact ? 48 : 60),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        WKCard(
          child: LayoutBuilder(
            builder: (context, c) {
              return Row(
                children: [
                  const CircleAvatar(
                    radius: 31,
                    backgroundColor: Color(0xFF102E69),
                    child: Icon(Icons.local_gas_station_rounded, color: WKColors.blue, size: 34),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on_rounded, color: WKColors.blue, size: 18),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text('Posto mais próximo', style: TextStyle(color: WKColors.blue, fontWeight: FontWeight.w800)),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text('Posto WK Ceres', style: TextStyle(fontSize: 18.5, fontWeight: FontWeight.w900)),
                        Text('Ceres - GO', style: TextStyle(color: WKColors.muted)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton.filled(
                    onPressed: () => toast(context, 'Rota do Posto WK Ceres será aberta aqui.'),
                    icon: const Icon(Icons.navigation_rounded),
                    tooltip: 'Ver rota',
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 18),
        const Row(
          children: [
            Expanded(child: Text('⛽  Combustíveis hoje', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900))),
            Text('Atualizado 08:30', style: TextStyle(color: WKColors.muted, fontSize: 11)),
          ],
        ),
        const SizedBox(height: 10),
        const Row(
          children: [
            Expanded(child: FuelBox('GASOLINA', 'R\$ 5,69', WKColors.red)),
            SizedBox(width: 8),
            Expanded(child: FuelBox('ETANOL', 'R\$ 3,89', WKColors.green)),
            SizedBox(width: 8),
            Expanded(child: FuelBox('DIESEL S10', 'R\$ 5,89', WKColors.blue)),
          ],
        ),
        const SizedBox(height: 20),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 18,
          crossAxisSpacing: 8,
          childAspectRatio: .86,
          children: [
            QuickAction(icon: Icons.stars_rounded, label: 'Pontos', onTap: () => showWKSheet(context, const PointsSheet())),
            QuickAction(icon: Icons.local_offer_rounded, label: 'Promoções', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PromotionsPage()))),
            QuickAction(icon: Icons.local_gas_station_rounded, label: 'Postos', onTap: () => toast(context, 'Abra a aba Postos na barra inferior.')),
            QuickAction(icon: Icons.build_rounded, label: 'Serviços', onTap: () => toast(context, 'Serviços por unidade serão conectados ao banco de dados.')),
            QuickAction(icon: Icons.confirmation_number_rounded, label: 'Cupons', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BenefitsPage()))),
            QuickAction(icon: Icons.support_agent_rounded, label: 'Suporte', onTap: () => toast(context, 'Canal de suporte em desenvolvimento.')),
          ],
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: WKColors.red, width: 1.35),
            gradient: const LinearGradient(colors: [Color(0xFF103A8B), Color(0xFF091D49)]),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 29,
                    backgroundColor: Color(0xFF102E69),
                    child: Icon(Icons.stars_rounded, color: Colors.white, size: 33),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Seus pontos', style: TextStyle(color: WKColors.muted)),
                        Text('1.250', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
                        Text('Faltam 750 pontos para o próximo benefício!', style: TextStyle(fontSize: 11.5)),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () => showWKSheet(context, const PointsSheet()),
                    child: const Text('Extrato'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: const LinearProgressIndicator(
                  value: .625,
                  minHeight: 8,
                  backgroundColor: Color(0xFF183B7C),
                  valueColor: AlwaysStoppedAnimation(WKColors.red),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class FuelBox extends StatelessWidget {
  final String title;
  final String price;
  final Color color;
  const FuelBox(this.title, this.price, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: WKColors.card2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(.55)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(child: Text(title, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w900))),
          const SizedBox(height: 8),
          FittedBox(child: Text(price, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900))),
          const Text('/LITRO', style: TextStyle(color: WKColors.muted, fontSize: 10)),
        ],
      ),
    );
  }
}

class QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const QuickAction({super.key, required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF102E75),
              border: Border.all(color: WKColors.red, width: 2),
              boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 12, offset: Offset(0, 6))],
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 7),
          FittedBox(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5))),
        ],
      ),
    );
  }
}

class BenefitsPage extends StatefulWidget {
  const BenefitsPage({super.key});

  @override
  State<BenefitsPage> createState() => _BenefitsPageState();
}

class _BenefitsPageState extends State<BenefitsPage> {
  final Set<int> active = {};

  @override
  Widget build(BuildContext context) {
    final data = [
      ('10% OFF na lavagem', 'Desconto especial para deixar seu veículo impecável.', '30/09/2026', Icons.local_car_wash_rounded),
      ('Café grátis', 'Ganhe 1 café em abastecimentos acima de R\$ 80.', '15/10/2026', Icons.coffee_rounded),
      ('Troca de óleo com desconto', 'Condição exclusiva em serviços selecionados.', '25/10/2026', Icons.oil_barrel_rounded),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      children: [
        const TitleBlock('Benefícios / Cupons', 'Promoções exclusivas para clientes WK.'),
        const SizedBox(height: 16),
        for (int i = 0; i < data.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: WKCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: const Color(0xFF102E69),
                    child: Icon(data[i].$4, color: WKColors.blue),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data[i].$1, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 4),
                        Text(data[i].$2, style: const TextStyle(color: WKColors.muted, height: 1.3)),
                        const SizedBox(height: 7),
                        Text('Válido até ${data[i].$3}', style: const TextStyle(color: WKColors.muted, fontSize: 12)),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () => setState(() => active.contains(i) ? active.remove(i) : active.add(i)),
                            style: FilledButton.styleFrom(backgroundColor: active.contains(i) ? WKColors.green : WKColors.blue),
                            child: Text(active.contains(i) ? 'CUPOM ATIVADO' : 'ATIVAR CUPOM'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class PromotionsPage extends StatelessWidget {
  const PromotionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WKBackdrop(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: const [
              BackHeader(title: 'Promoções'),
              SizedBox(height: 16),
              PromoCard(city: 'Querência - MT', title: 'WK Acessórios', offer: 'Ofertas especiais em acessórios automotivos.'),
              SizedBox(height: 12),
              PromoCard(city: 'Rio Verde - GO', title: 'WK Acessórios', offer: 'Seleção de produtos com preços promocionais.'),
              SizedBox(height: 12),
              PromoCard(city: 'Ceres - GO', title: 'Posto WK Ceres', offer: 'Benefícios exclusivos para clientes do programa WK.'),
            ],
          ),
        ),
      ),
    );
  }
}

class PromoCard extends StatelessWidget {
  final String city;
  final String title;
  final String offer;
  const PromoCard({super.key, required this.city, required this.title, required this.offer});

  @override
  Widget build(BuildContext context) {
    return WKCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.local_offer_rounded, color: WKColors.blue, size: 30),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
          Text(city, style: const TextStyle(color: WKColors.muted)),
          const SizedBox(height: 12),
          Text(offer),
          const SizedBox(height: 14),
          PrimaryButton(label: 'VER OFERTA', onTap: () => toast(context, 'Oferta demonstrativa do MVP.')),
        ],
      ),
    );
  }
}

class StationsPage extends StatelessWidget {
  const StationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stations = [
      ('Posto WK Ceres', 'Ceres - GO', '0 km', 'Combustível • Conveniência'),
      ('Posto WK Jaraguá', 'Jaraguá - GO', '61 km', 'Combustível • Conveniência'),
      ('Posto WK Anápolis', 'Anápolis - GO', '141 km', 'Combustível • Serviços'),
      ('Posto WK Rio Verde', 'Rio Verde - GO', '407 km', 'Combustível • WK Acessórios'),
      ('Posto WK Jataí', 'Jataí - GO', '496 km', 'Combustível • Conveniência'),
      ('Posto WK Querência', 'Querência - MT', '577 km', 'Combustível • WK Acessórios'),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      children: [
        const TitleBlock('Postos', 'Encontre uma unidade WK e veja os serviços disponíveis.'),
        const SizedBox(height: 15),
        const TextField(decoration: InputDecoration(hintText: 'Buscar posto ou cidade', prefixIcon: Icon(Icons.search_rounded))),
        const SizedBox(height: 15),
        for (final p in stations)
          Padding(
            padding: const EdgeInsets.only(bottom: 11),
            child: WKCard(
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0xFF102E69),
                    child: Icon(Icons.local_gas_station_rounded, color: WKColors.blue),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.$1, style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.w900)),
                        Text(p.$2, style: const TextStyle(color: WKColors.muted)),
                        const SizedBox(height: 4),
                        Text(p.$4, style: const TextStyle(color: WKColors.muted, fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    children: [
                      Text(p.$3, style: const TextStyle(color: WKColors.blue, fontWeight: FontWeight.w900)),
                      IconButton(
                        onPressed: () => toast(context, 'Rota para ${p.$1} será aberta aqui.'),
                        icon: const Icon(Icons.navigation_rounded),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      children: [
        const TitleBlock('Perfil / Histórico', 'Sua conta e movimentações no programa WK.'),
        const SizedBox(height: 16),
        const WKCard(
          child: Row(
            children: [
              CircleAvatar(
                radius: 31,
                backgroundColor: Color(0xFF102E69),
                child: Icon(Icons.person_rounded, color: WKColors.blue, size: 34),
              ),
              SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Lucas Araújo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                    Text('Cliente WK', style: TextStyle(color: WKColors.blue, fontWeight: FontWeight.w700)),
                    Text('Ceres - GO', style: TextStyle(color: WKColors.muted)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('1.250', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                  Text('pontos', style: TextStyle(color: WKColors.muted)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const HistoryItem('Posto WK Ceres', '08/08/2026', 'R\$ 198,50', '+198 pontos'),
        const HistoryItem('Posto WK Jaraguá', '27/07/2026', 'R\$ 142,20', '+142 pontos'),
        const HistoryItem('Posto WK Ceres', '10/07/2026', 'R\$ 211,90', '+211 pontos'),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (_) => false,
          ),
          icon: const Icon(Icons.logout_rounded),
          label: const Text('Sair da conta'),
        ),
      ],
    );
  }
}

class HistoryItem extends StatelessWidget {
  final String place;
  final String date;
  final String value;
  final String points;
  const HistoryItem(this.place, this.date, this.value, this.points, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: WKCard(
        child: Row(
          children: [
            const Icon(Icons.local_gas_station_rounded, color: WKColors.blue),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(place, style: const TextStyle(fontWeight: FontWeight.w800)),
                  Text(date, style: const TextStyle(color: WKColors.muted, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
                Text(points, style: const TextStyle(color: WKColors.green, fontWeight: FontWeight.w800, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PointsSheet extends StatelessWidget {
  const PointsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return const WKSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Extrato de pontos', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          SizedBox(height: 18),
          HistoryItem('Posto WK Ceres', '08/08/2026', 'Abastecimento', '+198 pontos'),
          HistoryItem('Cupom utilizado', '30/07/2026', 'Lavagem', '-500 pontos'),
          HistoryItem('Posto WK Jaraguá', '27/07/2026', 'Abastecimento', '+142 pontos'),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

class WKSheet extends StatelessWidget {
  final Widget child;
  const WKSheet({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      decoration: const BoxDecoration(
        color: WKColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      child: SafeArea(top: false, child: child),
    );
  }
}

class WKCard extends StatelessWidget {
  final Widget child;
  const WKCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: WKColors.card.withOpacity(.96),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: WKColors.border.withOpacity(.9)),
        boxShadow: const [BoxShadow(color: Color(0x26000000), blurRadius: 14, offset: Offset(0, 7))],
      ),
      child: child,
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const PrimaryButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: WKColors.blue,
          disabledBackgroundColor: WKColors.border,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: FittedBox(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w900))),
      ),
    );
  }
}

class TitleBlock extends StatelessWidget {
  final String title;
  final String subtitle;
  const TitleBlock(this.title, this.subtitle, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 29, fontWeight: FontWeight.w900)),
        const SizedBox(height: 5),
        Text(subtitle, style: const TextStyle(color: WKColors.muted, height: 1.35)),
      ],
    );
  }
}

class BackHeader extends StatelessWidget {
  final String title;
  const BackHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_rounded)),
        const SizedBox(width: 6),
        Expanded(child: Text(title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900))),
      ],
    );
  }
}

void toast(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(text), backgroundColor: WKColors.card2),
  );
}

void showWKSheet(BuildContext context, Widget child) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => child,
  );
}
