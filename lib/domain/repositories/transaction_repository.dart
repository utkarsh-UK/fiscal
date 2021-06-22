import 'package:dartz/dartz.dart';
import 'package:fiscal/core/error/failure.dart';
import 'package:fiscal/domain/enitities/transactions/transaction.dart';

abstract class TransactionRepository {
  Future<Either<Failure, List<Transaction>>> getRecentTransactions();

  Future<Either<Failure, Map<String, List<Transaction>>>> getAllTransactions(String lastFetchedTransactionID, String time,
      [int batchSize = 10]);

  Future<Either<Failure, String>> addNewTransaction(Transaction transaction);

  Future<Either<Failure, Map<String, Object?>>> getDailySummary();
}
