import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'app_controller.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/formatters.dart';
import 'models/coupon_model.dart';
import 'models/transaction_model.dart';
import 'services/auth_service.dart';
import 'services/coupon_service.dart';
import 'services/station_service.dart';
import 'widgets/brand_logo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppController.instance.initialize();
  runApp(const WKClienteApp());
}

class WKClienteApp extends StatelessWidget {
  const WKClienteApp({super.key});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: AppController.instance,
        builder: (_, __) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Grupo WK',
          theme: buildTheme(),
          home: AppController.instance.isLoggedIn
              ? const MainShell()
              : const LoginScreen(),
        ),
      );
}

void showMessage(BuildContext context, String text) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final identifier = TextEditingController();
  final password = TextEditingController();
  bool busy = false;

  @override
  void dispose() {
    identifier.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (identifier.text.trim().isEmpty || password.text.isEmpty) {
      showMessage(context, 'Preencha o e-mail/CPF e a senha.');
      return;
    }
    setState(() => busy = true);
    try {
      await AppController.instance.login(identifier.text, password.text);
    } on AuthException catch (error) {
      if (mounted) showMessage(context, error.message);
    }
    if (mounted) setState(() => busy = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 54),
              const Center(child: BrandLogo(size: 90)),
              const SizedBox(height: 18),
              const Text(
                'Grupo WK',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
              const Text(
                'Seu clube de vantagens WK',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.muted),
              ),
              const SizedBox(height: 34),
              TextField(
                controller: identifier,
                decoration: const InputDecoration(
                  labelText: 'E-mail ou CPF',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: password,
                obscureText: true,
                onSubmitted: (_) => submit(),
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: busy ? null : submit,
                child: Text(busy ? 'Entrando...' : 'Entrar'),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                ),
                child: const Text('Criar cadastro'),
              ),
            ],
          ),
        ),
      );
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final name = TextEditingController();
  final cpf = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmation = TextEditingController();
  bool terms = false;
  bool busy = false;

  @override
  void dispose() {
    for (final controller in [name, cpf, phone, email, password, confirmation]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> submit() async {
    if (password.text != confirmation.text) {
      showMessage(context, 'As senhas não conferem.');
      return;
    }
    setState(() => busy = true);
    try {
      await AppController.instance.register(
        name: name.text,
        cpf: cpf.text,
        phone: phone.text,
        email: email.text,
        password: password.text,
        acceptedTerms: terms,
      );
      if (mounted) Navigator.pop(context);
    } on AuthException catch (error) {
      if (mounted) showMessage(context, error.message);
    }
    if (mounted) setState(() => busy = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Criar conta')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            for (final field in [
              (name, 'Nome completo', TextInputType.name),
              (cpf, 'CPF', TextInputType.number),
              (phone, 'Telefone', TextInputType.phone),
              (email, 'E-mail', TextInputType.emailAddress),
            ]) ...[
              TextField(
                controller: field.$1,
                keyboardType: field.$3,
                decoration: InputDecoration(labelText: field.$2),
              ),
              const SizedBox(height: 10),
            ],
            TextField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha (mínimo 6 caracteres)'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: confirmation,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirmar senha'),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: terms,
              onChanged: (value) => setState(() => terms = value ?? false),
              title: const Text('Aceito os termos de uso e a política de privacidade.'),
            ),
            FilledButton(
              onPressed: busy ? null : submit,
              child: Text(busy ? 'Criando...' : 'Criar conta'),
            ),
          ],
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

  void navigate(int value) => setState(() => index = value);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          bottom: false,
          child: IndexedStack(
            index: index,
            children: [
              HomeScreen(onNavigate: navigate),
              const StationsScreen(),
              const BenefitsScreen(),
              const ProfileScreen(),
            ],
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: navigate,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Início',
            ),
            NavigationDestination(
              icon: Icon(Icons.local_gas_station_outlined),
              selectedIcon: Icon(Icons.local_gas_station_rounded),
              label: 'Postos',
            ),
            NavigationDestination(
              icon: Icon(Icons.star_border_rounded),
              selectedIcon: Icon(Icons.star_rounded),
              label: 'Benefícios',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Perfil',
            ),
          ],
        ),
      );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onNavigate});

  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: AppController.instance,
        builder: (_, __) {
          final app = AppController.instance;
          final user = app.user!;
          final firstName = user.name.trim().split(' ').first;
          final station = StationService.stations.first;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
            children: [
              Row(
                children: [
                  const BrandLogo(size: 66),
                  const SizedBox(width: 13),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GRUPO WK',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w900,
                            letterSpacing: .4,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Confia no Senhor de todo\no seu coração!',
                          style: TextStyle(color: AppColors.muted, height: 1.2),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(40),
                    onTap: () => onNavigate(3),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 22,
                            backgroundColor: AppColors.field,
                            child: Icon(Icons.person_outline, color: Colors.white),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Olá, $firstName!',
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => onNavigate(2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: AspectRatio(
                    aspectRatio: 2.34,
                    child: Image.asset(
                      'assets/images/banner_abasteca_pontos.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Dot(active: true),
                  _Dot(),
                  _Dot(),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 62,
                      height: 62,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryDark,
                        border: Border.all(color: AppColors.primary, width: 2),
                      ),
                      child: const Icon(Icons.local_gas_station_rounded, size: 32),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.location_on_rounded, color: AppColors.primary, size: 18),
                              SizedBox(width: 4),
                              Text(
                                'Posto em destaque',
                                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            station.name,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                          ),
                          Text(station.location, style: const TextStyle(color: AppColors.muted)),
                        ],
                      ),
                    ),
                    IconButton.filled(
                      onPressed: () => onNavigate(1),
                      icon: const Icon(Icons.arrow_forward_rounded),
                      tooltip: 'Ver postos',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const Row(
                children: [
                  Icon(Icons.local_gas_station_rounded),
                  SizedBox(width: 8),
                  Text('Combustíveis', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
                ],
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Expanded(child: _FuelCard(label: 'GASOLINA', icon: Icons.local_fire_department_rounded, accent: AppColors.danger)),
                  SizedBox(width: 8),
                  Expanded(child: _FuelCard(label: 'ETANOL', icon: Icons.water_drop_rounded, accent: AppColors.success)),
                  SizedBox(width: 8),
                  Expanded(child: _FuelCard(label: 'DIESEL S10', icon: Icons.opacity_rounded, accent: AppColors.primary)),
                ],
              ),
              const SizedBox(height: 24),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 18,
                crossAxisSpacing: 10,
                childAspectRatio: .95,
                children: [
                  _HomeAction(
                    icon: Icons.stars_rounded,
                    label: 'Pontos',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QrScreen())),
                  ),
                  _HomeAction(icon: Icons.percent_rounded, label: 'Promoções', onTap: () => onNavigate(2)),
                  _HomeAction(icon: Icons.local_gas_station_rounded, label: 'Postos', onTap: () => onNavigate(1)),
                  _HomeAction(icon: Icons.build_rounded, label: 'Serviços', onTap: () => showMessage(context, 'Serviços estarão disponíveis em breve.')),
                  _HomeAction(icon: Icons.local_activity_rounded, label: 'Cupons', onTap: () => onNavigate(2)),
                  _HomeAction(icon: Icons.headset_mic_rounded, label: 'Suporte', onTap: () => showMessage(context, 'Canal de suporte em preparação.')),
                ],
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0D2D78), Color(0xFF071A45)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.red, width: 1.4),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 62,
                      height: 62,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF071C57),
                        border: Border.all(color: AppColors.primary, width: 2),
                      ),
                      child: const Icon(Icons.stars_rounded, size: 34),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Seus pontos', style: TextStyle(color: AppColors.muted)),
                          Text(
                            '${app.points}',
                            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 7),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: LinearProgressIndicator(
                              minHeight: 7,
                              value: ((app.points % 1000) / 1000).clamp(0.05, 1.0),
                              backgroundColor: AppColors.primaryDark,
                              valueColor: const AlwaysStoppedAnimation(AppColors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen())),
                      child: const Text('Ver extrato'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Movimentações recentes',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              if (app.transactions.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(18),
                    child: Text('Nenhuma movimentação registrada.'),
                  ),
                )
              else
                for (final item in app.transactions.take(3)) ...[
                  TransactionTile(item),
                  const SizedBox(height: 8),
                ],
            ],
          );
        },
      );
}

class _Dot extends StatelessWidget {
  const _Dot({this.active = false});
  final bool active;

  @override
  Widget build(BuildContext context) => Container(
        width: active ? 8 : 7,
        height: active ? 8 : 7,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: active ? AppColors.primary : AppColors.muted.withValues(alpha: .45),
        ),
      );
}

class _FuelCard extends StatelessWidget {
  const _FuelCard({required this.label, required this.icon, required this.accent});
  final String label;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: accent.withValues(alpha: .45)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: accent, fontSize: 12, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Consulte\nno posto',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, height: 1.15),
                  ),
                ),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: accent,
                  child: Icon(icon, color: Colors.white, size: 19),
                ),
              ],
            ),
          ],
        ),
      );
}

class _HomeAction extends StatelessWidget {
  const _HomeAction({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 66,
              height: 66,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF071B50),
                border: Border.all(color: AppColors.primary, width: 2),
                boxShadow: const [
                  BoxShadow(color: Color(0x55FF2038), blurRadius: 0, spreadRadius: 4),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 31),
            ),
            const SizedBox(height: 9),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      );
}

class QrScreen extends StatelessWidget {
  const QrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppController.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Meu QR Code')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Identificação do cliente', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const Text('Mostre este código ao frentista.'),
                  const SizedBox(height: 20),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(12),
                    child: QrImageView(data: app.qrPayload, size: 220),
                  ),
                  const SizedBox(height: 16),
                  Text(app.user!.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('ID: ${app.user!.id}'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StationsScreen extends StatefulWidget {
  const StationsScreen({super.key});

  @override
  State<StationsScreen> createState() => _StationsScreenState();
}

class _StationsScreenState extends State<StationsScreen> {
  String query = '';
  final service = StationService();

  @override
  Widget build(BuildContext context) {
    final stations = service.search(query);
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text('Postos', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const Text('Encontre uma unidade WK', style: TextStyle(color: AppColors.muted)),
        const SizedBox(height: 16),
        TextField(
          onChanged: (value) => setState(() => query = value),
          decoration: const InputDecoration(
            labelText: 'Buscar por posto ou cidade',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        const SizedBox(height: 14),
        for (final station in stations) ...[
          Card(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: const CircleAvatar(
                backgroundColor: AppColors.primaryDark,
                child: Icon(Icons.local_gas_station_rounded),
              ),
              title: Text(station.name, style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(station.location),
              trailing: const Icon(Icons.chevron_right_rounded),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class BenefitsScreen extends StatelessWidget {
  const BenefitsScreen({super.key});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: AppController.instance,
        builder: (_, __) {
          final app = AppController.instance;
          return ListView(
            padding: const EdgeInsets.all(18),
            children: [
              const Text('Benefícios', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              Text('Saldo: ${app.points} pontos', style: const TextStyle(color: AppColors.muted)),
              const SizedBox(height: 14),
              for (final coupon in CouponService.coupons) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: AppColors.primaryDark,
                              child: Icon(Icons.local_offer_rounded),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(coupon.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(coupon.description),
                        const SizedBox(height: 4),
                        Text('${coupon.pointsCost} pontos • ${coupon.rules}', style: const TextStyle(color: AppColors.muted)),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: app.isRedeemed(coupon.id) ? null : () => redeem(context, coupon),
                            child: Text(app.isRedeemed(coupon.id) ? 'Resgatado' : 'Resgatar'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ],
          );
        },
      );

  Future<void> redeem(BuildContext context, CouponModel coupon) async {
    try {
      await AppController.instance.redeem(coupon);
      if (context.mounted) showMessage(context, 'Cupom resgatado com sucesso.');
    } on CouponException catch (error) {
      if (context.mounted) showMessage(context, error.message);
    }
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: AppController.instance,
        builder: (_, __) {
          final app = AppController.instance;
          final user = app.user!;
          return ListView(
            padding: const EdgeInsets.all(18),
            children: [
              const Text('Perfil', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 28,
                            backgroundColor: AppColors.primaryDark,
                            child: Icon(Icons.person_rounded, size: 30),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user.name, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                                Text(user.email, style: const TextStyle(color: AppColors.muted)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 28),
                      Text(user.phone),
                      Text('CPF: ${maskCpf(user.cpf)}'),
                      const SizedBox(height: 12),
                      Text('${app.points} pontos', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen())),
                icon: const Icon(Icons.receipt_long),
                label: const Text('Histórico completo'),
              ),
              if (kDebugMode) ...[
                const SizedBox(height: 8),
                FilledButton.tonalIcon(
                  onPressed: () => showDialog(context: context, builder: (_) => const DemoFuelingDialog()),
                  icon: const Icon(Icons.developer_mode),
                  label: const Text('Ferramenta de desenvolvimento'),
                ),
              ],
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: app.logout,
                icon: const Icon(Icons.logout),
                label: const Text('Sair'),
              ),
            ],
          );
        },
      );
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Histórico')),
        body: AnimatedBuilder(
          animation: AppController.instance,
          builder: (_, __) {
            final items = AppController.instance.transactions;
            return ListView(
              padding: const EdgeInsets.all(18),
              children: items.isEmpty
                  ? [const Text('Nenhuma movimentação registrada.')]
                  : [for (final item in items) ...[TransactionTile(item), const SizedBox(height: 8)]],
            );
          },
        ),
      );
}

class TransactionTile extends StatelessWidget {
  const TransactionTile(this.item, {super.key});

  final TransactionModel item;

  @override
  Widget build(BuildContext context) {
    final redemption = item.type == TransactionType.couponRedemption;
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: redemption ? const Color(0xFF4A1730) : AppColors.primaryDark,
          child: Icon(redemption ? Icons.local_offer : Icons.local_gas_station),
        ),
        title: Text(redemption ? 'Cupom utilizado' : item.stationName, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text('${formatDate(item.date)}${item.fuel.isEmpty ? '' : ' • ${item.fuel}'}'),
        trailing: Text(
          '${item.points > 0 ? '+' : ''}${item.points} pts',
          style: TextStyle(
            color: item.points >= 0 ? AppColors.success : AppColors.danger,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class DemoFuelingDialog extends StatefulWidget {
  const DemoFuelingDialog({super.key});

  @override
  State<DemoFuelingDialog> createState() => _DemoFuelingDialogState();
}

class _DemoFuelingDialogState extends State<DemoFuelingDialog> {
  final amount = TextEditingController();
  final liters = TextEditingController();
  var station = StationService.stations.first;
  String fuel = 'Gasolina';

  @override
  void dispose() {
    amount.dispose();
    liters.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Somente desenvolvimento'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField(
                initialValue: station,
                items: [
                  for (final item in StationService.stations)
                    DropdownMenuItem(value: item, child: Text(item.name)),
                ],
                onChanged: (value) => setState(() => station = value!),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                initialValue: fuel,
                items: [
                  for (final item in ['Gasolina', 'Etanol', 'Diesel S10', 'Diesel S500'])
                    DropdownMenuItem(value: item, child: Text(item)),
                ],
                onChanged: (value) => setState(() => fuel = value!),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: amount,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Valor em R\$'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: liters,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Litros (opcional)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          FilledButton(onPressed: submit, child: const Text('Simular')),
        ],
      );

  Future<void> submit() async {
    final value = double.tryParse(amount.text.replaceAll(',', '.'));
    final volume = double.tryParse(liters.text.replaceAll(',', '.'));
    if (value == null || value <= 0) {
      showMessage(context, 'Informe um valor válido.');
      return;
    }
    try {
      final transaction = await AppController.instance.recordDemoFueling(
        station: station,
        amount: value,
        fuel: fuel,
        liters: volume,
      );
      if (mounted) {
        Navigator.pop(context);
        showMessage(context, 'Abastecimento simulado: +${transaction.points} pontos.');
      }
    } on ArgumentError catch (error) {
      if (mounted) {
        showMessage(context, error.message?.toString() ?? 'Valor inválido.');
      }
    }
  }
}
