import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

import '../models/user_model.dart';
import '../repositories/customer_repository.dart';

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;
  @override String toString() => message;
}

class AuthService {
  AuthService(this.repository, {Random? random}) : _random = random ?? Random.secure();
  final CustomerRepository repository;
  final Random _random;
  String normalizeDigits(String value) => value.replaceAll(RegExp(r'\D'), '');
  String hashPassword(String password) => sha256.convert(utf8.encode(password)).toString();

  Future<UserModel> register({required String name, required String cpf, required String phone, required String email, required String password, required bool acceptedTerms}) async {
    name = name.trim(); cpf = normalizeDigits(cpf); phone = normalizeDigits(phone); email = email.trim().toLowerCase();
    if (!acceptedTerms) throw const AuthException('Aceite os termos para continuar.');
    if (name.split(RegExp(r'\s+')).length < 2) throw const AuthException('Informe seu nome completo.');
    if (cpf.length != 11) throw const AuthException('Informe um CPF com 11 dígitos.');
    if (phone.length < 10 || phone.length > 11) throw const AuthException('Informe um telefone válido.');
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) throw const AuthException('Informe um e-mail válido.');
    if (password.length < 6) throw const AuthException('A senha precisa ter pelo menos 6 caracteres.');
    if (repository.users.any((user) => user.email.toLowerCase() == email)) throw const AuthException('Já existe uma conta com este e-mail.');
    if (repository.users.any((user) => user.cpf == cpf)) throw const AuthException('Já existe uma conta com este CPF.');
    final id = 'WK-${DateTime.now().microsecondsSinceEpoch}-${_random.nextInt(999999).toString().padLeft(6, '0')}';
    final user = UserModel(id: id, name: name, cpf: cpf, phone: phone, email: email, passwordHash: hashPassword(password));
    await repository.saveUsers([...repository.users, user]);
    await repository.saveSession(id);
    return user;
  }

  Future<UserModel> login(String identifier, String password) async {
    final normalized = identifier.trim().toLowerCase();
    final cpf = normalizeDigits(normalized);
    UserModel? match;
    for (final user in repository.users) { if (user.email.toLowerCase() == normalized || (cpf.length == 11 && user.cpf == cpf)) { match = user; break; } }
    if (match == null || match.passwordHash != hashPassword(password)) throw const AuthException('E-mail/CPF ou senha incorretos.');
    await repository.saveSession(match.id);
    return match;
  }
}
