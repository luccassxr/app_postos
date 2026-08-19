import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';
import '../repositories/customer_repository.dart';
import 'auth_service.dart';

class FirebaseCustomerAuthService {
  FirebaseCustomerAuthService(this.repository);

  final CustomerRepository repository;

  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  String normalizeDigits(String value) => value.replaceAll(RegExp(r'\D'), '');

  Future<UserModel?> restoreAuthenticatedUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) {
      await repository.saveSession(null);
      return null;
    }

    final user = await _loadProfile(firebaseUser.uid);
    if (user == null) {
      await _auth.signOut();
      await repository.saveSession(null);
      return null;
    }

    await _cacheUser(user);
    return user;
  }

  Future<UserModel> register({
    required String name,
    required String cpf,
    required String phone,
    required String email,
    required String password,
    required bool acceptedTerms,
  }) async {
    name = name.trim();
    cpf = normalizeDigits(cpf);
    phone = normalizeDigits(phone);
    email = email.trim().toLowerCase();

    _validateRegistration(
      name: name,
      cpf: cpf,
      phone: phone,
      email: email,
      password: password,
      acceptedTerms: acceptedTerms,
    );

    if (repository.users.any((user) => user.cpf == cpf)) {
      throw const AuthException('Já existe uma conta com este CPF neste aparelho.');
    }

    UserCredential credential;
    try {
      credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      throw AuthException(_messageForAuthError(error));
    }

    final firebaseUser = credential.user;
    if (firebaseUser == null) {
      throw const AuthException('Não foi possível criar a conta. Tente novamente.');
    }

    final user = UserModel(
      id: firebaseUser.uid,
      name: name,
      cpf: cpf,
      phone: phone,
      email: email,
      passwordHash: '',
    );

    try {
      await _firestore.collection('customers').doc(user.id).set({
        'id': user.id,
        'name': user.name,
        'cpf': user.cpf,
        'phone': user.phone,
        'email': user.email,
        'role': 'customer',
        'active': true,
        'points': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (error) {
      try {
        await firebaseUser.delete();
      } catch (_) {}
      throw AuthException(
        error.code == 'permission-denied'
            ? 'O Firebase ainda não permite salvar o perfil. Verifique as regras do Firestore.'
            : 'Não foi possível salvar seu perfil no Firebase. Tente novamente.',
      );
    }

    await _cacheUser(user);
    return user;
  }

  Future<UserModel> login(String identifier, String password) async {
    final normalized = identifier.trim().toLowerCase();
    String email = normalized;

    if (!normalized.contains('@')) {
      final cpf = normalizeDigits(normalized);
      UserModel? localMatch;
      for (final user in repository.users) {
        if (user.cpf == cpf) {
          localMatch = user;
          break;
        }
      }
      if (localMatch == null) {
        throw const AuthException(
          'Para entrar neste aparelho pela primeira vez, use o e-mail cadastrado.',
        );
      }
      email = localMatch.email;
    }

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw const AuthException('Não foi possível entrar. Tente novamente.');
      }

      final user = await _loadProfile(firebaseUser.uid);
      if (user == null) {
        await _auth.signOut();
        throw const AuthException('Perfil do cliente não encontrado no Firestore.');
      }

      await _cacheUser(user);
      return user;
    } on FirebaseAuthException catch (error) {
      throw AuthException(_messageForAuthError(error));
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    await repository.saveSession(null);
  }

  Future<UserModel?> _loadProfile(String uid) async {
    try {
      final snapshot = await _firestore.collection('customers').doc(uid).get();
      final data = snapshot.data();
      if (!snapshot.exists || data == null) return null;
      return UserModel(
        id: uid,
        name: (data['name'] as String?) ?? '',
        cpf: (data['cpf'] as String?) ?? '',
        phone: (data['phone'] as String?) ?? '',
        email: (data['email'] as String?) ?? (_auth.currentUser?.email ?? ''),
        passwordHash: '',
      );
    } on FirebaseException catch (error) {
      if (error.code == 'permission-denied') {
        throw const AuthException(
          'O Firebase não permitiu acessar o perfil. Verifique as regras do Firestore.',
        );
      }
      throw const AuthException('Não foi possível carregar seu perfil.');
    }
  }

  Future<void> _cacheUser(UserModel user) async {
    final users = [...repository.users.where((item) => item.id != user.id), user];
    await repository.saveUsers(users);
    await repository.saveSession(user.id);
  }

  void _validateRegistration({
    required String name,
    required String cpf,
    required String phone,
    required String email,
    required String password,
    required bool acceptedTerms,
  }) {
    if (!acceptedTerms) {
      throw const AuthException('Aceite os termos para continuar.');
    }
    if (name.split(RegExp(r'\s+')).length < 2) {
      throw const AuthException('Informe seu nome completo.');
    }
    if (cpf.length != 11) {
      throw const AuthException('Informe um CPF com 11 dígitos.');
    }
    if (phone.length < 10 || phone.length > 11) {
      throw const AuthException('Informe um telefone válido.');
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      throw const AuthException('Informe um e-mail válido.');
    }
    if (password.length < 6) {
      throw const AuthException('A senha precisa ter pelo menos 6 caracteres.');
    }
  }

  String _messageForAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case 'email-already-in-use':
        return 'Já existe uma conta com este e-mail.';
      case 'invalid-email':
        return 'Informe um e-mail válido.';
      case 'weak-password':
        return 'A senha é muito fraca.';
      case 'user-disabled':
        return 'Esta conta foi desativada.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'E-mail/CPF ou senha incorretos.';
      case 'network-request-failed':
        return 'Sem conexão com a internet. Tente novamente.';
      case 'too-many-requests':
        return 'Muitas tentativas. Aguarde um pouco e tente novamente.';
      default:
        return 'Não foi possível autenticar. Tente novamente.';
    }
  }
}
