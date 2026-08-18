import 'package:app_postos/app_controller.dart';
import 'package:app_postos/models/coupon_model.dart';
import 'package:app_postos/models/transaction_model.dart';
import 'package:app_postos/models/user_model.dart';
import 'package:app_postos/repositories/customer_repository.dart';
import 'package:app_postos/services/auth_service.dart';
import 'package:app_postos/services/coupon_service.dart';
import 'package:app_postos/services/loyalty_service.dart';
import 'package:app_postos/services/qr_service.dart';
import 'package:app_postos/services/station_service.dart';
import 'package:flutter_test/flutter_test.dart';

class MemoryRepository implements CustomerRepository {
  List<UserModel> mutableUsers = [];
  List<TransactionModel> mutableTransactions = [];
  String? mutableSession;
  Set<String> mutableCoupons = {};
  @override Future<void> initialize() async {}
  @override List<UserModel> get users => List.unmodifiable(mutableUsers);
  @override List<TransactionModel> get transactions => List.unmodifiable(mutableTransactions);
  @override String? get sessionUserId => mutableSession;
  @override Set<String> get redeemedCouponKeys => Set.unmodifiable(mutableCoupons);
  @override Future<void> saveUsers(List<UserModel> value) async => mutableUsers = List.of(value);
  @override Future<void> saveTransactions(List<TransactionModel> value) async => mutableTransactions = List.of(value);
  @override Future<void> saveSession(String? value) async => mutableSession = value;
  @override Future<void> saveRedeemedCoupons(Set<String> value) async => mutableCoupons = Set.of(value);
}

Future<AppController> registeredController() async {
  final controller = AppController(MemoryRepository());
  await controller.initialize();
  await controller.register(name: 'Maria da Silva', cpf: '123.456.789-00', phone: '(62) 99999-9999', email: 'maria@example.com', password: '123456', acceptedTerms: true);
  return controller;
}

void main() {
  group('autenticação local', () {
    test('cadastra, normaliza dados, cria ID e restaura login', () async {
      final repository = MemoryRepository();
      final auth = AuthService(repository);
      final user = await auth.register(name: 'Maria da Silva', cpf: '123.456.789-00', phone: '(62) 99999-9999', email: 'MARIA@example.com', password: '123456', acceptedTerms: true);
      expect(user.id, startsWith('WK-'));
      expect(user.cpf, '12345678900');
      expect(user.passwordHash, isNot('123456'));
      expect((await auth.login('123.456.789-00', '123456')).id, user.id);
      expect(repository.sessionUserId, user.id);
    });

    test('impede e-mail e CPF duplicados', () async {
      final repository = MemoryRepository();
      final auth = AuthService(repository);
      await auth.register(name: 'Maria da Silva', cpf: '12345678900', phone: '62999999999', email: 'maria@example.com', password: '123456', acceptedTerms: true);
      await expectLater(auth.register(name: 'Outra Pessoa', cpf: '99999999999', phone: '62988888888', email: 'MARIA@example.com', password: '123456', acceptedTerms: true), throwsA(isA<AuthException>()));
      await expectLater(auth.register(name: 'Outra Pessoa', cpf: '12345678900', phone: '62988888888', email: 'outra@example.com', password: '123456', acceptedTerms: true), throwsA(isA<AuthException>()));
    });
  });

  test('regra de pontos trunca centavos e calcula saldo', () {
    const loyalty = LoyaltyService();
    expect(loyalty.pointsForFueling(150.80), 150);
    final transactions = [TransactionModel(id: '1', customerId: 'u', date: DateTime(2026), stationId: 's', stationName: 'Posto', amount: 150.8, fuel: 'Etanol', points: 150, type: TransactionType.fueling), TransactionModel(id: '2', customerId: 'u', date: DateTime(2026), stationId: '', stationName: 'Benefícios', amount: 0, fuel: '', points: -50, type: TransactionType.couponRedemption)];
    expect(loyalty.balance(transactions), 100);
  });

  test('QR contém somente prefixo e ID e pode ser interpretado', () {
    final service = QrService();
    final payload = service.generate('WK-123');
    expect(payload, 'WKCLIENT:WK-123');
    expect(service.parse(payload), 'WK-123');
    expect(payload, isNot(contains('cpf')));
  });

  group('transações e cupons', () {
    test('cria abastecimento completo e atualiza saldo', () async {
      final controller = await registeredController();
      final item = await controller.recordDemoFueling(station: StationService.stations.first, amount: 99.90, fuel: 'Gasolina', liters: 16.2);
      expect(item.points, 99);
      expect(item.customerId, controller.user!.id);
      expect(item.fuel, 'Gasolina');
      expect(controller.points, 99);
      expect(controller.transactions.single.id, item.id);
    });

    test('bloqueia cupom sem saldo e permite resgate persistente', () async {
      final controller = await registeredController();
      final coupon = CouponModel(id: 'test', title: 'Teste', description: 'Teste', expiresAt: DateTime(2099), pointsCost: 50, rules: 'Único');
      await expectLater(controller.redeem(coupon), throwsA(isA<CouponException>()));
      await controller.recordDemoFueling(station: StationService.stations.first, amount: 80, fuel: 'Etanol');
      final redemption = await controller.redeem(coupon);
      expect(redemption.points, -50);
      expect(controller.points, 30);
      expect(controller.isRedeemed(coupon.id), isTrue);
      await expectLater(controller.redeem(coupon), throwsA(isA<CouponException>()));
    });
  });
}
