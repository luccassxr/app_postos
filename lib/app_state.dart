import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WKUser {
  final String id;
  final String name;
  final String cpf;
  final String phone;
  final String email;
  final String passwordHash;
  final int points;
  final String city;

  const WKUser({
    required this.id,
    required this.name,
    required this.cpf,
    required this.phone,
    required this.email,
    required this.passwordHash,
    required this.points,
    required this.city,
  });

  WKUser copyWith({int? points}) => WKUser(
        id: id,
        name: name,
        cpf: cpf,
        phone: phone,
        email: email,
        passwordHash: passwordHash,
        points: points ?? this.points,
        city: city,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'cpf': cpf,
        'phone': phone,
        'email': email,
        'passwordHash': passwordHash,
        'points': points,
        'city': city,
      };

  factory WKUser.fromJson(Map<String, dynamic> json) => WKUser(
        id: json['id'] as String,
        name: json['name'] as String,
        cpf: json['cpf'] as String,
        phone: json['phone'] as String,
        email: json['email'] as String,
        passwordHash: json['passwordHash'] as String,
        points: (json['points'] as num?)?.toInt() ?? 0,
        city: json['city'] as String? ?? 'Ceres - GO',
      );
}

class WKHistoryEntry {
  final String id;
  final String userId;
  final String place;
  final DateTime date;
  final double value;
  final int pointsDelta;
  final String type;

  const WKHistoryEntry({
    required this.id,
    required this.userId,
    required this.place,
    required this.date,
    required this.value,
    required this.pointsDelta,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'place': place,
        'date': date.toIso8601String(),
        'value': value,
        'pointsDelta': pointsDelta,
        'type': type,
      };

  factory WKHistoryEntry.fromJson(Map<String, dynamic> json) => WKHistoryEntry(
        id: json['id'] as String,
        userId: json['userId'] as String,
        place: json['place'] as String,
        date: DateTime.parse(json['date'] as String),
        value: (json['value'] as num).toDouble(),
        pointsDelta: (json['pointsDelta'] as num).toInt(),
        type: json['type'] as String? ?? 'abastecimento',
      );
}

class WKCoupon {
  final String id;
  final String title;
  final String description;
  final String validUntil;
  final int costPoints;

  const WKCoupon({
    required this.id,
    required this.title,
    required this.description,
    required this.validUntil,
    required this.costPoints,
  });
}

class AppStore extends ChangeNotifier {
  AppStore._();
  static final AppStore instance = AppStore._();

  static const _usersKey = 'wk_users_v1';
  static const _sessionKey = 'wk_session_v1';
  static const _historyKey = 'wk_history_v1';
  static const _activatedCouponsKey = 'wk_activated_coupons_v1';

  SharedPreferences? _prefs;
  final List<WKUser> _users = [];
  final List<WKHistoryEntry> _history = [];
  final Set<String> _activatedCoupons = {};
  String? _currentUserId;

  WKUser? get currentUser {
    final id = _currentUserId;
    if (id == null) return null;
    for (final user in _users) {
      if (user.id == id) return user;
    }
    return null;
  }

  bool get isLoggedIn => currentUser != null;
  Set<String> get activatedCoupons => Set.unmodifiable(_activatedCoupons);

  List<WKHistoryEntry> get currentHistory {
    final user = currentUser;
    if (user == null) return const [];
    final list = _history.where((e) => e.userId == user.id).toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  static const coupons = <WKCoupon>[
    WKCoupon(
      id: 'wash10',
      title: '10% OFF na lavagem',
      description: 'Desconto especial para deixar seu veículo impecável.',
      validUntil: '30/09/2026',
      costPoints: 0,
    ),
    WKCoupon(
      id: 'coffee',
      title: 'Café grátis',
      description: 'Ganhe 1 café em abastecimentos acima de R\$ 80.',
      validUntil: '15/10/2026',
      costPoints: 0,
    ),
    WKCoupon(
      id: 'oil',
      title: 'Troca de óleo com desconto',
      description: 'Condição exclusiva em serviços selecionados.',
      validUntil: '25/10/2026',
      costPoints: 0,
    ),
  ];

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _load();
    await _seedDemoIfNeeded();
  }

  void _load() {
    final prefs = _prefs!;
    _users
      ..clear()
      ..addAll(_decodeList(prefs.getString(_usersKey)).map(WKUser.fromJson));
    _history
      ..clear()
      ..addAll(_decodeList(prefs.getString(_historyKey)).map(WKHistoryEntry.fromJson));
    _activatedCoupons
      ..clear()
      ..addAll(prefs.getStringList(_activatedCouponsKey) ?? const []);
    _currentUserId = prefs.getString(_sessionKey);
  }

  List<Map<String, dynamic>> _decodeList(String? raw) {
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.cast<Map<String, dynamic>>();
    } catch (_) {
      return const [];
    }
  }

  Future<void> _seedDemoIfNeeded() async {
    if (_users.isNotEmpty) return;
    final demo = WKUser(
      id: 'WK-DEMO-0001',
      name: 'Lucas Araújo',
      cpf: '00000000000',
      phone: '62999999999',
      email: 'demo@wk.com',
      passwordHash: _hash('123456'),
      points: 1250,
      city: 'Ceres - GO',
    );
    _users.add(demo);
    _history.addAll([
      WKHistoryEntry(
        id: 'h1',
        userId: demo.id,
        place: 'Posto WK Ceres',
        date: DateTime(2026, 8, 8),
        value: 198.50,
        pointsDelta: 198,
        type: 'abastecimento',
      ),
      WKHistoryEntry(
        id: 'h2',
        userId: demo.id,
        place: 'Posto WK Jaraguá',
        date: DateTime(2026, 7, 27),
        value: 142.20,
        pointsDelta: 142,
        type: 'abastecimento',
      ),
      WKHistoryEntry(
        id: 'h3',
        userId: demo.id,
        place: 'Posto WK Ceres',
        date: DateTime(2026, 7, 10),
        value: 211.90,
        pointsDelta: 211,
        type: 'abastecimento',
      ),
    ]);
    await _persist();
  }

  String _hash(String value) => sha256.convert(utf8.encode(value)).toString();
  String normalizeDigits(String value) => value.replaceAll(RegExp(r'\D'), '');

  bool isValidEmail(String email) => RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim());
  bool isValidCpfShape(String cpf) => normalizeDigits(cpf).length == 11;
  bool isValidPhoneShape(String phone) {
    final digits = normalizeDigits(phone);
    return digits.length >= 10 && digits.length <= 11;
  }

  Future<String?> register({
    required String name,
    required String cpf,
    required String phone,
    required String email,
    required String password,
  }) async {
    name = name.trim();
    cpf = normalizeDigits(cpf);
    phone = normalizeDigits(phone);
    email = email.trim().toLowerCase();

    if (name.length < 3) return 'Informe seu nome completo.';
    if (!isValidCpfShape(cpf)) return 'Informe um CPF com 11 dígitos.';
    if (!isValidPhoneShape(phone)) return 'Informe um telefone válido.';
    if (!isValidEmail(email)) return 'Informe um e-mail válido.';
    if (password.length < 6) return 'A senha precisa ter pelo menos 6 caracteres.';
    if (_users.any((u) => u.email == email)) return 'Já existe uma conta com este e-mail.';
    if (_users.any((u) => u.cpf == cpf)) return 'Já existe uma conta com este CPF.';

    final id = 'WK-${DateTime.now().millisecondsSinceEpoch}';
    final user = WKUser(
      id: id,
      name: name,
      cpf: cpf,
      phone: phone,
      email: email,
      passwordHash: _hash(password),
      points: 0,
      city: 'Ceres - GO',
    );
    _users.add(user);
    _currentUserId = id;
    await _persist();
    notifyListeners();
    return null;
  }

  Future<String?> login(String identifier, String password) async {
    identifier = identifier.trim().toLowerCase();
    final digits = normalizeDigits(identifier);
    WKUser? found;
    for (final user in _users) {
      if (user.email == identifier || (digits.length == 11 && user.cpf == digits)) {
        found = user;
        break;
      }
    }
    if (found == null || found.passwordHash != _hash(password)) {
      return 'E-mail/CPF ou senha incorretos.';
    }
    _currentUserId = found.id;
    await _prefs!.setString(_sessionKey, found.id);
    notifyListeners();
    return null;
  }

  Future<void> logout() async {
    _currentUserId = null;
    await _prefs!.remove(_sessionKey);
    notifyListeners();
  }

  Future<void> setCouponActive(String couponId, bool active) async {
    final user = currentUser;
    if (user == null) return;
    final key = '${user.id}:$couponId';
    active ? _activatedCoupons.add(key) : _activatedCoupons.remove(key);
    await _prefs!.setStringList(_activatedCouponsKey, _activatedCoupons.toList());
    notifyListeners();
  }

  bool isCouponActive(String couponId) {
    final user = currentUser;
    if (user == null) return false;
    return _activatedCoupons.contains('${user.id}:$couponId');
  }

  Future<void> addTransactionForTesting({
    required String place,
    required double value,
  }) async {
    final user = currentUser;
    if (user == null) return;
    final gained = value.floor();
    final index = _users.indexWhere((u) => u.id == user.id);
    _users[index] = user.copyWith(points: user.points + gained);
    _history.add(WKHistoryEntry(
      id: 'H-${DateTime.now().microsecondsSinceEpoch}',
      userId: user.id,
      place: place,
      date: DateTime.now(),
      value: value,
      pointsDelta: gained,
      type: 'abastecimento',
    ));
    await _persist();
    notifyListeners();
  }

  String qrPayload() {
    final user = currentUser;
    if (user == null) return 'WK:NO_SESSION';
    return jsonEncode({
      'v': 1,
      'type': 'wk_customer',
      'customerId': user.id,
    });
  }

  Future<void> _persist() async {
    final prefs = _prefs!;
    await prefs.setString(_usersKey, jsonEncode(_users.map((e) => e.toJson()).toList()));
    await prefs.setString(_historyKey, jsonEncode(_history.map((e) => e.toJson()).toList()));
    await prefs.setStringList(_activatedCouponsKey, _activatedCoupons.toList());
    if (_currentUserId != null) {
      await prefs.setString(_sessionKey, _currentUserId!);
    }
  }
}
