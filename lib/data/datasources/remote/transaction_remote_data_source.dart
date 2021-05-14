import 'package:fiscal/domain/enitities/entities.dart';

abstract class TransactionRemoteDataSource {
  Future<List<Transaction>> getRecentTransactions();
  Future<Map<String, List<Transaction>>> getAllTransactions([int batchSize = 10]);
}