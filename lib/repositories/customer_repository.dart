import '../models/transaction_model.dart';
import '../models/user_model.dart';

abstract interface class CustomerRepository {
  Future<void> initialize();
  List<UserModel> get users;
  List<TransactionModel> get transactions;
  String? get sessionUserId;
  Set<String> get redeemedCouponKeys;
  Future<void> saveUsers(List<UserModel> users);
  Future<void> saveTransactions(List<TransactionModel> transactions);
  Future<void> saveSession(String? userId);
  Future<void> saveRedeemedCoupons(Set<String> keys);
}
