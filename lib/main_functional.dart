import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStore.instance.init();
  runApp(const WKFunctionalApp());
}

class C {
  static const bg = Color(0xFF020712);
  static const bg2 = Color(0xFF07162D);
  static const card = Color(0xFF0A1729);
  static const card2 = Color(0xFF0E1D34);
  static const blue = Color(0xFF1768FF);
  static const red = Color(0xFFFF1830);
  static const green = Color(0xFF25D87A);
  static const text = Color(0xFFF7F9FF);
  static const muted = Color(0xFFA7B1C3);
  static const border = Color(0xFF2B3C57);
}

class WKFunctionalApp extends StatelessWidget {
  const WKFunctionalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppStore.instance,
      builder: (_, __) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'WK Cliente',
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: C.bg,
          colorScheme: const ColorScheme.dark(primary: C.blue, secondary: C.red, surface: C.card),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: C.card2,
            hintStyle: const TextStyle(color: C.muted),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: C.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: C.blue),
            ),
          ),
        ),
        home: AppStore.instance.isLoggedIn ? const MainShell() : const LoginPage(),
      ),
    );
  }
}

class Backdrop extends StatelessWidget {
  final Widget child;
  const Backdrop({super.key, required this.child});
  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -.45),
            radius: 1.2,
            colors: [Color(0xFF0A2D63), C.bg2, C.bg, Color(0xFF000308)],
            stops: [0, .35, .72, 1],
          ),
        ),
        child: child,
      );
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
  bool busy = false;

  Future<void> submit() async {
    if (login.text.trim().isEmpty || password.text.isEmpty) {
      message('Preencha o e-mail/CPF e a senha.');
      return;
    }
    setState(() => busy = true);
    final error = await AppStore.instance.login(login.text, password.text);
    if (!mounted) return;
    setState(() => busy = false);
    if (error != null) message(error);
  }

  void message(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Backdrop(
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 36),
                const Icon(Icons.local_gas_station_rounded, size: 72, color: C.blue),
                const SizedBox(height: 18),
                const Text('WK Cliente', textAlign: TextAlign.center, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                const Text('Acesse sua conta para acompanhar pontos, cupons e abastecimentos.', textAlign: TextAlign.center, style: TextStyle(color: C.muted)),
                const SizedBox(height: 32),
                CardBox(
                  child: Column(
                    children: [
                      TextField(controller: login, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'E-mail ou CPF', prefixIcon: Icon(Icons.person_outline))),
                      const SizedBox(height: 12),
                      TextField(
                        controller: password,
                        obscureText: hide,
                        onSubmitted: (_) => busy ? null : submit(),
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(onPressed: () => setState(() => hide = !hide), icon: Icon(hide ? Icons.visibility_outlined : Icons.visibility_off_outlined)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(width: double.infinity, child: FilledButton(onPressed: busy ? null : submit, child: Text(busy ? 'ENTRANDO...' : 'ENTRAR'))),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage())), child: const Text('Criar cadastro')),
                const SizedBox(height: 18),
                const Card(
                  color: C.card,
                  child: Padding(
                    padding: EdgeInsets.all(14),
                    child: Text('Conta para teste\nE-mail: demo@wk.com\nSenha: 123456', textAlign: TextAlign.center, style: TextStyle(color: C.muted)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final name = TextEditingController();
  final cpf = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirm = TextEditingController();
  bool accepted = false;
  bool busy = false;

  Future<void> submit() async {
    if (!accepted) return;
    if (password.text != confirm.text) {
      show('As senhas não conferem.');
      return;
    }
    setState(() => busy = true);
    final error = await AppStore.instance.register(
      name: name.text,
      cpf: cpf.text,
      phone: phone.text,
      email: email.text,
      password: password.text,
    );
    if (!mounted) return;
    setState(() => busy = false);
    if (error != null) show(error);
  }

  void show(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Criar conta'), backgroundColor: C.bg),
        body: Backdrop(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              CardBox(
                child: Column(
                  children: [
                    TextField(controller: name, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: 'Nome completo')),
                    const SizedBox(height: 10),
                    TextField(controller: cpf, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'CPF')),
                    const SizedBox(height: 10),
                    TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Telefone')),
                    const SizedBox(height: 10),
                    TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'E-mail')),
                    const SizedBox(height: 10),
                    TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Senha')),
                    const SizedBox(height: 10),
                    TextField(controller: confirm, obscureText: true, decoration: const InputDecoration(labelText: 'Confirmar senha')),
                    CheckboxListTile(value: accepted, contentPadding: EdgeInsets.zero, onChanged: (v) => setState(() => accepted = v ?? false), title: const Text('Aceito os termos de uso e a política de privacidade.', style: TextStyle(fontSize: 13))),
                    SizedBox(width: double.infinity, child: FilledButton(onPressed: accepted && !busy ? submit : null, child: Text(busy ? 'CRIANDO...' : 'CRIAR CONTA'))),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final pages = const [HomePage(), StationsPage(), BenefitsPage(), ProfilePage()];
    return Scaffold(
      body: Backdrop(child: SafeArea(child: pages[index])),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (v) => setState(() => index = v),
        backgroundColor: const Color(0xFF030C1B),
        indicatorColor: const Color(0xFF123A83),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Início'),
          NavigationDestination(icon: Icon(Icons.local_gas_station_outlined), selectedIcon: Icon(Icons.local_gas_station), label: 'Postos'),
          NavigationDestination(icon: Icon(Icons.local_offer_outlined), selectedIcon: Icon(Icons.local_offer), label: 'Benefícios'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: AppStore.instance,
        builder: (_, __) {
          final u = AppStore.instance.currentUser!;
          return ListView(
            padding: const EdgeInsets.all(18),
            children: [
              Text('Olá, ${u.name.split(' ').first}!', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
              const Text('Bem-vindo ao programa de fidelidade WK.', style: TextStyle(color: C.muted)),
              const SizedBox(height: 18),
              CardBox(
                child: Row(
                  children: [
                    const CircleAvatar(radius: 28, backgroundColor: Color(0xFF102E69), child: Icon(Icons.stars_rounded, color: C.blue)),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Seus pontos', style: TextStyle(color: C.muted)), Text('${u.points}', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900))])),
                    IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomerQRPage())), icon: const Icon(Icons.qr_code_2_rounded, color: C.blue, size: 34)),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              CardBox(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Posto mais próximo', style: TextStyle(color: C.blue, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  const Text('Posto WK Ceres', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                  const Text('Ceres - GO', style: TextStyle(color: C.muted)),
                  const SizedBox(height: 12),
                  SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Integração com mapas será adicionada na etapa online.'))), icon: const Icon(Icons.navigation_rounded), label: const Text('VER ROTA'))),
                ]),
              ),
              const SizedBox(height: 18),
              const Text('Acesso rápido', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: ActionCard(icon: Icons.qr_code_2_rounded, label: 'Meu QR', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomerQRPage())))),
                const SizedBox(width: 10),
                Expanded(child: ActionCard(icon: Icons.receipt_long_rounded, label: 'Extrato', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryPage())))),
              ]),
              const SizedBox(height: 18),
              const Text('Últimos abastecimentos', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              if (AppStore.instance.currentHistory.isEmpty)
                const CardBox(child: Text('Nenhum abastecimento registrado ainda.', style: TextStyle(color: C.muted)))
              else
                for (final h in AppStore.instance.currentHistory.take(3)) HistoryTile(h),
            ],
          );
        },
      );
}

class CustomerQRPage extends StatelessWidget {
  const CustomerQRPage({super.key});
  @override
  Widget build(BuildContext context) {
    final user = AppStore.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(title: const Text('Meu QR Code'), backgroundColor: C.bg),
      body: Backdrop(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: CardBox(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text('Identificação do cliente', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                const Text('Mostre este código ao frentista.', style: TextStyle(color: C.muted)),
                const SizedBox(height: 20),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(14),
                  child: QrImageView(data: AppStore.instance.qrPayload(), version: QrVersions.auto, size: 220, backgroundColor: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(user.name, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
                Text('ID: ${user.id}', style: const TextStyle(color: C.muted, fontSize: 12)),
                const SizedBox(height: 6),
                Text('${user.points} pontos', style: const TextStyle(color: C.blue, fontWeight: FontWeight.w900)),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class BenefitsPage extends StatelessWidget {
  const BenefitsPage({super.key});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: AppStore.instance,
        builder: (_, __) => ListView(
          padding: const EdgeInsets.all(18),
          children: [
            const Text('Benefícios / Cupons', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
            const Text('Ative benefícios e eles ficarão salvos neste aparelho.', style: TextStyle(color: C.muted)),
            const SizedBox(height: 16),
            for (final coupon in AppStore.coupons)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CardBox(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(coupon.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    Text(coupon.description, style: const TextStyle(color: C.muted)),
                    const SizedBox(height: 6),
                    Text('Válido até ${coupon.validUntil}', style: const TextStyle(color: C.muted, fontSize: 12)),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(backgroundColor: AppStore.instance.isCouponActive(coupon.id) ? C.green : C.blue),
                        onPressed: () => AppStore.instance.setCouponActive(coupon.id, !AppStore.instance.isCouponActive(coupon.id)),
                        child: Text(AppStore.instance.isCouponActive(coupon.id) ? 'CUPOM ATIVADO' : 'ATIVAR CUPOM'),
                      ),
                    ),
                  ]),
                ),
              ),
          ],
        ),
      );
}

class StationsPage extends StatefulWidget {
  const StationsPage({super.key});
  @override
  State<StationsPage> createState() => _StationsPageState();
}

class _StationsPageState extends State<StationsPage> {
  String query = '';
  static const stations = [
    ('Posto WK Ceres', 'Ceres - GO', 'Combustível • Conveniência'),
    ('Posto WK Jaraguá', 'Jaraguá - GO', 'Combustível • Conveniência'),
    ('Posto WK Anápolis', 'Anápolis - GO', 'Combustível • Serviços'),
    ('Posto WK Rio Verde', 'Rio Verde - GO', 'Combustível • WK Acessórios'),
    ('Posto WK Jataí', 'Jataí - GO', 'Combustível • Conveniência'),
    ('Posto WK Querência', 'Querência - MT', 'Combustível • WK Acessórios'),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = stations.where((e) => '${e.$1} ${e.$2}'.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text('Postos', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
        const SizedBox(height: 12),
        TextField(onChanged: (v) => setState(() => query = v), decoration: const InputDecoration(hintText: 'Buscar posto ou cidade', prefixIcon: Icon(Icons.search))),
        const SizedBox(height: 14),
        for (final p in filtered)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: CardBox(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(backgroundColor: Color(0xFF102E69), child: Icon(Icons.local_gas_station_rounded, color: C.blue)),
                title: Text(p.$1, style: const TextStyle(fontWeight: FontWeight.w900)),
                subtitle: Text('${p.$2}\n${p.$3}'),
                isThreeLine: true,
                trailing: const Icon(Icons.chevron_right),
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
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: AppStore.instance,
        builder: (_, __) {
          final u = AppStore.instance.currentUser!;
          return ListView(
            padding: const EdgeInsets.all(18),
            children: [
              const Text('Perfil / Histórico', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
              const SizedBox(height: 14),
              CardBox(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(u.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                  const Text('Cliente WK', style: TextStyle(color: C.blue, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  Text(u.email),
                  Text(u.phone),
                  Text(u.city, style: const TextStyle(color: C.muted)),
                  const SizedBox(height: 12),
                  Text('${u.points} pontos', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                ]),
              ),
              const SizedBox(height: 12),
              SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryPage())), icon: const Icon(Icons.receipt_long), label: const Text('Ver histórico completo'))),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonalIcon(
                  onPressed: () async {
                    await AppStore.instance.addTransactionForTesting(place: 'Posto WK Ceres', value: 100.00);
                    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Abastecimento de teste adicionado: +100 pontos.')));
                  },
                  icon: const Icon(Icons.science_outlined),
                  label: const Text('Simular abastecimento de teste'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: () => AppStore.instance.logout(), icon: const Icon(Icons.logout), label: const Text('Sair da conta'))),
            ],
          );
        },
      );
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Histórico'), backgroundColor: C.bg),
        body: Backdrop(
          child: AnimatedBuilder(
            animation: AppStore.instance,
            builder: (_, __) => ListView(
              padding: const EdgeInsets.all(18),
              children: [
                if (AppStore.instance.currentHistory.isEmpty)
                  const CardBox(child: Text('Nenhuma movimentação registrada.', style: TextStyle(color: C.muted)))
                else
                  for (final h in AppStore.instance.currentHistory) HistoryTile(h),
              ],
            ),
          ),
        ),
      );
}

class HistoryTile extends StatelessWidget {
  final WKHistoryEntry entry;
  const HistoryTile(this.entry, {super.key});
  @override
  Widget build(BuildContext context) {
    final d = entry.date;
    final date = '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
    final value = 'R\$ ${entry.value.toStringAsFixed(2).replaceAll('.', ',')}';
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: CardBox(
        child: Row(children: [
          const Icon(Icons.local_gas_station_rounded, color: C.blue),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(entry.place, style: const TextStyle(fontWeight: FontWeight.w800)), Text(date, style: const TextStyle(color: C.muted, fontSize: 12))])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text(value, style: const TextStyle(fontWeight: FontWeight.w900)), Text('${entry.pointsDelta >= 0 ? '+' : ''}${entry.pointsDelta} pontos', style: TextStyle(color: entry.pointsDelta >= 0 ? C.green : C.red, fontWeight: FontWeight.w800, fontSize: 12))]),
        ]),
      ),
    );
  }
}

class CardBox extends StatelessWidget {
  final Widget child;
  const CardBox({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: C.card.withOpacity(.96), borderRadius: BorderRadius.circular(20), border: Border.all(color: C.border)),
        child: child,
      );
}

class ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const ActionCard({super.key, required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: CardBox(child: Column(children: [Icon(icon, color: C.blue, size: 34), const SizedBox(height: 8), Text(label, style: const TextStyle(fontWeight: FontWeight.w800))])),
      );
}
