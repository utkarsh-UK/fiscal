import 'package:dartz/dartz.dart';
import 'package:fiscal/core/error/failure.dart';
import 'package:fiscal/domain/enitities/transactions/transaction.dart';

abstract class TransactionRepository {
  Future<Either<Failure, List<Transaction>>> getRecentTransactions();
  Future<Either<Failure, List<Transaction>>> getAllTransactions({int batchSize = 10});
}