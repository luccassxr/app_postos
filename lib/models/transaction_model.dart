enum TransactionType { fueling, couponRedemption }

class TransactionModel {
  const TransactionModel({required this.id, required this.customerId, required this.date, required this.stationId, required this.stationName, required this.amount, required this.fuel, this.liters, required this.points, required this.type, this.couponId});
  final String id;
  final String customerId;
  final DateTime date;
  final String stationId;
  final String stationName;
  final double amount;
  final String fuel;
  final double? liters;
  final int points;
  final TransactionType type;
  final String? couponId;

  Map<String, Object?> toJson() => {'id': id, 'customerId': customerId, 'date': date.toIso8601String(), 'stationId': stationId, 'stationName': stationName, 'amount': amount, 'fuel': fuel, 'liters': liters, 'points': points, 'type': type.name, 'couponId': couponId};
  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(id: json['id'] as String, customerId: json['customerId'] as String, date: DateTime.parse(json['date'] as String), stationId: json['stationId'] as String? ?? '', stationName: json['stationName'] as String, amount: (json['amount'] as num?)?.toDouble() ?? 0, fuel: json['fuel'] as String? ?? '', liters: (json['liters'] as num?)?.toDouble(), points: (json['points'] as num).toInt(), type: TransactionType.values.firstWhere((value) => value.name == json['type'], orElse: () => TransactionType.fueling), couponId: json['couponId'] as String?);
}
