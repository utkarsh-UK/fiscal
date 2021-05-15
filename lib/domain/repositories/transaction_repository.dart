import 'package:dartz/dartz.dart';
import 'package:fiscal/core/error/failure.dart';
import 'package:fiscal/domain/enitities/transactions/transaction.dart';

abstract class TransactionRepository {
  Future<Either<Failure, List<Transaction>>> getRecentTransactions();
  Future<Either<Failure, Map<String, List<Transaction>>>> getAllTransactions(String lastFetchedTransactionID, [int batchSize =
  10]);
}