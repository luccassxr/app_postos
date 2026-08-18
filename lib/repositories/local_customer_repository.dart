import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/transaction_model.dart';
import '../models/user_model.dart';
import 'customer_repository.dart';

/// Persistência exclusiva do MVP. Substitua esta classe por uma implementação
/// Firebase sem alterar controllers ou telas.
class LocalCustomerRepository implements CustomerRepository {
  static const _usersKey = 'wk_users_v2';
  static const _transactionsKey = 'wk_transactions_v2';
  static const _sessionKey = 'wk_session_v2';
  static const _couponsKey = 'wk_redeemed_coupons_v2';
  late SharedPreferences _preferences;
  List<UserModel> _users = [];
  List<TransactionModel> _transactions = [];

  @override Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
    _users = _decode(_preferences.getString(_usersKey)).map(UserModel.fromJson).toList();
    _transactions = _decode(_preferences.getString(_transactionsKey)).map(TransactionModel.fromJson).toList();
  }

  List<Map<String, dynamic>> _decode(String? value) {
    if (value == null) return [];
    try { return (jsonDecode(value) as List).cast<Map<String, dynamic>>(); } catch (_) { return []; }
  }

  @override List<UserModel> get users => List.unmodifiable(_users);
  @override List<TransactionModel> get transactions => List.unmodifiable(_transactions);
  @override String? get sessionUserId => _preferences.getString(_sessionKey);
  @override Set<String> get redeemedCouponKeys => (_preferences.getStringList(_couponsKey) ?? []).toSet();
  @override Future<void> saveUsers(List<UserModel> users) async { _users = List.of(users); await _preferences.setString(_usersKey, jsonEncode(users.map((user) => user.toJson()).toList())); }
  @override Future<void> saveTransactions(List<TransactionModel> transactions) async { _transactions = List.of(transactions); await _preferences.setString(_transactionsKey, jsonEncode(transactions.map((item) => item.toJson()).toList())); }
  @override Future<void> saveSession(String? userId) async {
    if (userId == null) {
      await _preferences.remove(_sessionKey);
    } else {
      await _preferences.setString(_sessionKey, userId);
    }
  }
  @override Future<void> saveRedeemedCoupons(Set<String> keys) async {
    await _preferences.setStringList(_couponsKey, keys.toList());
  }
}
