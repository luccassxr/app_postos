import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'firebase_options.dart';
import 'models/coupon_model.dart';
import 'models/station_model.dart';
import 'models/transaction_model.dart';
import 'models/user_model.dart';
import 'repositories/customer_repository.dart';
import 'repositories/local_customer_repository.dart';
import 'services/auth_service.dart';
import 'services/coupon_service.dart';
import 'services/loyalty_service.dart';
import 'services/qr_service.dart';

class AppController extends ChangeNotifier {
  AppController(this.repository)
      : auth = AuthService(repository),
        loyalty = const LoyaltyService();
  static final instance = AppController(LocalCustomerRepository());
  final CustomerRepository repository;
  final AuthService auth;
  final LoyaltyService loyalty;
  final couponService = CouponService();
  final qrService = QrService();
  UserModel? _user;

  UserModel? get user => _user;
  bool get isLoggedIn => _user != null;
  List<TransactionModel> get transactions {
    final result = repository.transactions.where((item) => item.customerId == _user?.id).toList()..sort((a, b) => b.date.compareTo(a.date));
    return result;
  }
  int get points => loyalty.balance(transactions);
  String get qrPayload => qrService.generate(_user!.id);
  bool isRedeemed(String couponId) => repository.redeemedCouponKeys.contains('${_user!.id}:$couponId');

  Future<void> initialize() async {
    // Firebase belongs to the production singleton. Unit tests create isolated
    // controllers with in-memory repositories and must not require platform
    // channels or a native Firebase runtime.
    if (identical(this, AppController.instance)) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    await repository.initialize();
    final session = repository.sessionUserId;
    for (final item in repository.users) { if (item.id == session) { _user = item; break; } }
  }

  Future<void> register({required String name, required String cpf, required String phone, required String email, required String password, required bool acceptedTerms}) async {
    _user = await auth.register(name: name, cpf: cpf, phone: phone, email: email, password: password, acceptedTerms: acceptedTerms);
    notifyListeners();
  }
  Future<void> login(String identifier, String password) async { _user = await auth.login(identifier, password); notifyListeners(); }
  Future<void> logout() async { _user = null; await repository.saveSession(null); notifyListeners(); }

  Future<TransactionModel> recordDemoFueling({required StationModel station, required double amount, required String fuel, double? liters}) async {
    if (_user == null) throw StateError('Nenhum cliente autenticado.');
    final item = TransactionModel(id: 'TX-${DateTime.now().microsecondsSinceEpoch}', customerId: _user!.id, date: DateTime.now(), stationId: station.id, stationName: station.name, amount: amount, fuel: fuel, liters: liters, points: loyalty.pointsForFueling(amount), type: TransactionType.fueling);
    await repository.saveTransactions([...repository.transactions, item]);
    notifyListeners();
    return item;
  }

  Future<TransactionModel> redeem(CouponModel coupon) async {
    if (_user == null) throw StateError('Nenhum cliente autenticado.');
    couponService.validateRedemption(coupon, balance: points, alreadyRedeemed: isRedeemed(coupon.id));
    final item = TransactionModel(id: 'TX-${DateTime.now().microsecondsSinceEpoch}', customerId: _user!.id, date: DateTime.now(), stationId: '', stationName: 'Benefícios WK', amount: 0, fuel: '', points: -coupon.pointsCost, type: TransactionType.couponRedemption, couponId: coupon.id);
    await repository.saveTransactions([...repository.transactions, item]);
    await repository.saveRedeemedCoupons({...repository.redeemedCouponKeys, '${_user!.id}:${coupon.id}'});
    notifyListeners();
    return item;
  }
}
