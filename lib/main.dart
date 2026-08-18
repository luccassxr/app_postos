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
          title: 'WK Cliente',
          theme: buildTheme(),
          home: AppController.instance.isLoggedIn ? const MainShell() : const LoginScreen(),
        ),
      );
}

void showMessage(BuildContext context, String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final identifier = TextEditingController(), password = TextEditingController();
  bool busy = false;
  @override void dispose() { identifier.dispose(); password.dispose(); super.dispose(); }
  Future<void> submit() async {
    if (identifier.text.trim().isEmpty || password.text.isEmpty) { showMessage(context, 'Preencha o e-mail/CPF e a senha.'); return; }
    setState(() => busy = true);
    try { await AppController.instance.login(identifier.text, password.text); } on AuthException catch (error) { if (mounted) showMessage(context, error.message); }
    if (mounted) setState(() => busy = false);
  }
  @override Widget build(BuildContext context) => Scaffold(body: SafeArea(child: ListView(padding: const EdgeInsets.all(24), children: [
    const SizedBox(height: 48), const BrandLogo(size: 76), const Text('WK Cliente', textAlign: TextAlign.center, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
    const SizedBox(height: 32), TextField(controller: identifier, decoration: const InputDecoration(labelText: 'E-mail ou CPF', prefixIcon: Icon(Icons.person_outline))), const SizedBox(height: 12),
    TextField(controller: password, obscureText: true, onSubmitted: (_) => submit(), decoration: const InputDecoration(labelText: 'Senha', prefixIcon: Icon(Icons.lock_outline))), const SizedBox(height: 18),
    FilledButton(onPressed: busy ? null : submit, child: Text(busy ? 'Entrando...' : 'Entrar')), TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())), child: const Text('Criar cadastro')),
  ])));
}

class RegisterScreen extends StatefulWidget { const RegisterScreen({super.key}); @override State<RegisterScreen> createState() => _RegisterScreenState(); }
class _RegisterScreenState extends State<RegisterScreen> {
  final name = TextEditingController(), cpf = TextEditingController(), phone = TextEditingController(), email = TextEditingController(), password = TextEditingController(), confirmation = TextEditingController();
  bool terms = false, busy = false;
  @override void dispose() { for (final c in [name, cpf, phone, email, password, confirmation]) { c.dispose(); } super.dispose(); }
  Future<void> submit() async {
    if (password.text != confirmation.text) { showMessage(context, 'As senhas não conferem.'); return; }
    setState(() => busy = true);
    try {
      await AppController.instance.register(name: name.text, cpf: cpf.text, phone: phone.text, email: email.text, password: password.text, acceptedTerms: terms);
      if (mounted) Navigator.pop(context);
    } on AuthException catch (error) { if (mounted) showMessage(context, error.message); }
    if (mounted) setState(() => busy = false);
  }
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Criar conta')), body: ListView(padding: const EdgeInsets.all(20), children: [
    for (final field in [(name, 'Nome completo', TextInputType.name), (cpf, 'CPF', TextInputType.number), (phone, 'Telefone', TextInputType.phone), (email, 'E-mail', TextInputType.emailAddress)]) ...[TextField(controller: field.$1, keyboardType: field.$3, decoration: InputDecoration(labelText: field.$2)), const SizedBox(height: 10)],
    TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Senha (mínimo 6 caracteres)')), const SizedBox(height: 10), TextField(controller: confirmation, obscureText: true, decoration: const InputDecoration(labelText: 'Confirmar senha')),
    CheckboxListTile(contentPadding: EdgeInsets.zero, value: terms, onChanged: (value) => setState(() => terms = value ?? false), title: const Text('Aceito os termos de uso e a política de privacidade.')),
    FilledButton(onPressed: busy ? null : submit, child: Text(busy ? 'Criando...' : 'Criar conta')),
  ]));
}

class MainShell extends StatefulWidget { const MainShell({super.key}); @override State<MainShell> createState() => _MainShellState(); }
class _MainShellState extends State<MainShell> {
  int index = 0;
  @override Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: IndexedStack(index: index, children: const [HomeScreen(), StationsScreen(), BenefitsScreen(), ProfileScreen()])),
    bottomNavigationBar: NavigationBar(selectedIndex: index, onDestinationSelected: (value) => setState(() => index = value), destinations: const [
      NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Início'), NavigationDestination(icon: Icon(Icons.local_gas_station_outlined), label: 'Postos'), NavigationDestination(icon: Icon(Icons.local_offer_outlined), label: 'Cupons'), NavigationDestination(icon: Icon(Icons.person_outline), label: 'Perfil'),
    ]),
  );
}

class HomeScreen extends StatelessWidget { const HomeScreen({super.key});
  @override Widget build(BuildContext context) => AnimatedBuilder(animation: AppController.instance, builder: (_, __) { final app = AppController.instance, user = app.user!; return ListView(padding: const EdgeInsets.all(18), children: [
    Text('Olá, ${user.name.split(' ').first}!', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)), const Text('Bem-vindo ao programa de fidelidade WK.'), const SizedBox(height: 16),
    Card(child: ListTile(leading: const Icon(Icons.stars, size: 38), title: const Text('Saldo de pontos'), subtitle: Text('${app.points}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)), trailing: IconButton(icon: const Icon(Icons.qr_code_2, size: 36), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QrScreen()))))),
    const SizedBox(height: 12), Row(children: [Expanded(child: FilledButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QrScreen())), icon: const Icon(Icons.qr_code), label: const Text('Meu QR'))), const SizedBox(width: 8), Expanded(child: OutlinedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen())), icon: const Icon(Icons.receipt_long), label: const Text('Extrato')))]),
    const SizedBox(height: 20), const Text('Movimentações recentes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), if (app.transactions.isEmpty) const Card(child: Padding(padding: EdgeInsets.all(18), child: Text('Nenhuma movimentação registrada.'))) else for (final item in app.transactions.take(3)) TransactionTile(item),
  ]); });
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
                  const Text(
                    'Identificação do cliente',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('Mostre este código ao frentista.'),
                  const SizedBox(height: 20),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(12),
                    child: QrImageView(data: app.qrPayload, size: 220),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    app.user!.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
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

class StationsScreen extends StatefulWidget { const StationsScreen({super.key}); @override State<StationsScreen> createState() => _StationsScreenState(); }
class _StationsScreenState extends State<StationsScreen> { String query = ''; final service = StationService(); @override Widget build(BuildContext context) { final stations = service.search(query); return ListView(padding: const EdgeInsets.all(18), children: [const Text('Postos', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)), const SizedBox(height: 12), TextField(onChanged: (value) => setState(() => query = value), decoration: const InputDecoration(labelText: 'Buscar por posto ou cidade', prefixIcon: Icon(Icons.search))), const SizedBox(height: 12), for (final station in stations) Card(child: ListTile(leading: const Icon(Icons.local_gas_station), title: Text(station.name), subtitle: Text(station.location))) ]); } }

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
              const Text(
                'Cupons',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Text('Saldo: ${app.points} pontos'),
              const SizedBox(height: 12),
              for (final coupon in CouponService.coupons)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coupon.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(coupon.description),
                        Text(
                          '${coupon.pointsCost} pontos • ${coupon.rules}',
                          style: const TextStyle(color: AppColors.muted),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: app.isRedeemed(coupon.id)
                                ? null
                                : () => redeem(context, coupon),
                            child: Text(
                              app.isRedeemed(coupon.id)
                                  ? 'Resgatado'
                                  : 'Resgatar',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      );

  Future<void> redeem(BuildContext context, CouponModel coupon) async {
    try {
      await AppController.instance.redeem(coupon);
      if (context.mounted) {
        showMessage(context, 'Cupom resgatado com sucesso.');
      }
    } on CouponException catch (error) {
      if (context.mounted) showMessage(context, error.message);
    }
  }
}

class ProfileScreen extends StatelessWidget { const ProfileScreen({super.key}); @override Widget build(BuildContext context) => AnimatedBuilder(animation: AppController.instance, builder: (_, __) { final app = AppController.instance, user = app.user!; return ListView(padding: const EdgeInsets.all(18), children: [
  const Text('Perfil', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)), Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(user.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), Text(user.email), Text(user.phone), Text('CPF: ${maskCpf(user.cpf)}'), Text('ID: ${user.id}'), Text('${app.points} pontos', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))]))),
  OutlinedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen())), icon: const Icon(Icons.receipt_long), label: const Text('Histórico completo')),
  if (kDebugMode) FilledButton.tonalIcon(onPressed: () => showDialog(context: context, builder: (_) => const DemoFuelingDialog()), icon: const Icon(Icons.developer_mode), label: const Text('Ferramenta de desenvolvimento')),
  OutlinedButton.icon(onPressed: app.logout, icon: const Icon(Icons.logout), label: const Text('Sair')),
]); }); }

class HistoryScreen extends StatelessWidget { const HistoryScreen({super.key}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Histórico')), body: AnimatedBuilder(animation: AppController.instance, builder: (_, __) { final items = AppController.instance.transactions; return ListView(padding: const EdgeInsets.all(18), children: items.isEmpty ? [const Text('Nenhuma movimentação registrada.')] : [for (final item in items) TransactionTile(item)]; })); }
class TransactionTile extends StatelessWidget { const TransactionTile(this.item, {super.key}); final TransactionModel item; @override Widget build(BuildContext context) { final redemption = item.type == TransactionType.couponRedemption; return Card(child: ListTile(leading: Icon(redemption ? Icons.local_offer : Icons.local_gas_station), title: Text(redemption ? 'Cupom utilizado' : item.stationName), subtitle: Text('${formatDate(item.date)}${item.fuel.isEmpty ? '' : ' • ${item.fuel}'}'), trailing: Text('${item.points > 0 ? '+' : ''}${item.points} pts', style: TextStyle(color: item.points >= 0 ? AppColors.success : AppColors.danger, fontWeight: FontWeight.bold)))); } }

class DemoFuelingDialog extends StatefulWidget { const DemoFuelingDialog({super.key}); @override State<DemoFuelingDialog> createState() => _DemoFuelingDialogState(); }
class _DemoFuelingDialogState extends State<DemoFuelingDialog> { final amount = TextEditingController(), liters = TextEditingController(); var station = StationService.stations.first; String fuel = 'Gasolina'; @override void dispose() { amount.dispose(); liters.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => AlertDialog(title: const Text('Somente desenvolvimento'), content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [DropdownButtonFormField(initialValue: station, items: [for (final item in StationService.stations) DropdownMenuItem(value: item, child: Text(item.name))], onChanged: (value) => setState(() => station = value!)), const SizedBox(height: 10), DropdownButtonFormField(initialValue: fuel, items: [for (final item in ['Gasolina', 'Etanol', 'Diesel S10', 'Diesel S500']) DropdownMenuItem(value: item, child: Text(item))], onChanged: (value) => setState(() => fuel = value!)), const SizedBox(height: 10), TextField(controller: amount, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Valor em R\$')), const SizedBox(height: 10), TextField(controller: liters, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Litros (opcional)'))])), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')), FilledButton(onPressed: submit, child: const Text('Simular'))]);
  Future<void> submit() async { final value = double.tryParse(amount.text.replaceAll(',', '.')), volume = double.tryParse(liters.text.replaceAll(',', '.')); if (value == null || value <= 0) { showMessage(context, 'Informe um valor válido.'); return; } try { final transaction = await AppController.instance.recordDemoFueling(station: station, amount: value, fuel: fuel, liters: volume); if (mounted) { Navigator.pop(context); showMessage(context, 'Abastecimento simulado: +${transaction.points} pontos.'); } } on ArgumentError catch (error) { if (mounted) showMessage(context, error.message?.toString() ?? 'Valor inválido.'); } }
}
