import 'package:fiscal/domain/enitities/entities.dart';

abstract class TransactionLocalDataSource {
  Future<List<Transaction>> getRecentTransactions();
  Future<void> cacheRecentTransactions(List<Transaction> transactions);
  Future<void> cacheNewTransaction(Transaction transaction);
}