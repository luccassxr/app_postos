import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/transaction_model.dart';

class FirebaseLoyaltyService {
  FirebaseLoyaltyService({FirebaseFirestore? firestore}) : _firestore = firestore;

  final FirebaseFirestore? _firestore;

  FirebaseFirestore get _db => _firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _transactions(String customerId) =>
      _db.collection('customers').doc(customerId).collection('transactions');

  Stream<List<TransactionModel>> watchTransactions(String customerId) {
    return _transactions(customerId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              final rawDate = data['date'];
              final date = rawDate is Timestamp
                  ? rawDate.toDate()
                  : DateTime.tryParse(rawDate?.toString() ?? '') ??
                      DateTime.fromMillisecondsSinceEpoch(0);
              final typeName = data['type']?.toString() ?? 'fueling';
              final type = TransactionType.values.firstWhere(
                (value) => value.name == typeName,
                orElse: () => TransactionType.fueling,
              );
              return TransactionModel(
                id: doc.id,
                customerId: customerId,
                date: date,
                stationId: data['stationId']?.toString() ?? '',
                stationName: data['stationName']?.toString() ?? '',
                amount: (data['amount'] as num?)?.toDouble() ?? 0,
                fuel: data['fuel']?.toString() ?? '',
                liters: (data['liters'] as num?)?.toDouble(),
                points: (data['points'] as num?)?.toInt() ?? 0,
                type: type,
                couponId: data['couponId']?.toString(),
              );
            }).toList());
  }

  Future<TransactionModel> redeemCoupon({
    required String customerId,
    required String couponId,
    required String title,
    required int pointsCost,
  }) async {
    final doc = _transactions(customerId).doc('redeem_$couponId');
    final snapshot = await doc.get();
    if (snapshot.exists) {
      throw StateError('Este cupom já foi resgatado.');
    }

    final item = TransactionModel(
      id: doc.id,
      customerId: customerId,
      date: DateTime.now(),
      stationId: '',
      stationName: 'Benefícios WK',
      amount: 0,
      fuel: '',
      points: -pointsCost,
      type: TransactionType.couponRedemption,
      couponId: couponId,
    );

    await doc.set({
      'customerId': customerId,
      'date': FieldValue.serverTimestamp(),
      'stationId': '',
      'stationName': 'Benefícios WK',
      'amount': 0,
      'fuel': '',
      'liters': null,
      'points': -pointsCost,
      'type': TransactionType.couponRedemption.name,
      'couponId': couponId,
      'couponTitle': title,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return item;
  }
}
