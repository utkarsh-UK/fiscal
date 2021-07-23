import 'package:dartz/dartz.dart';
import 'package:fiscal/core/error/failure.dart';
import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/domain/enitities/core/category.dart';
import 'package:fiscal/domain/enitities/transactions/transaction.dart';

abstract class TransactionRepository {
  /// Fetches 10 most recent transactions.
  Future<Either<Failure, List<Transaction>>> getRecentTransactions();

  /// Fetches all transactions for specified [time] with given [batchSize].
  ///
  /// If [lastFetchedTransactionID] is not empty, method will fetch transactions after this [lastFetchedTransactionID].
  Future<Either<Failure, Map<String, List<Transaction>>>> getAllTransactions(String lastFetchedTransactionID, String time,
      [int batchSize = 10]);

  /// Adds this new [transaction] to database and cache sub-sequently.
  Future<Either<Failure, String>> addNewTransaction(Transaction transaction);

  /// Fetched summary for current month.
  ///
  /// Returns [Map<>] with {INCOME, EXPENSE} keys.
  Future<Either<Failure, Map<String, Object?>>> getDailySummary();

  /// Fetches all categories for given [type].
  ///
  /// [type] can be INCOME/EXPENSE.
  Future<Either<Failure, List<Category>>> getCategories(TransactionType type);
}
