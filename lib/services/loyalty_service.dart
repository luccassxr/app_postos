import '../models/transaction_model.dart';

class LoyaltyService {
  const LoyaltyService();
  int pointsForFueling(double amount) {
    if (!amount.isFinite || amount <= 0) throw ArgumentError.value(amount, 'amount', 'O valor deve ser positivo.');
    return amount.floor();
  }

  int balance(Iterable<TransactionModel> transactions) => transactions.fold(0, (total, transaction) => total + transaction.points);
}
