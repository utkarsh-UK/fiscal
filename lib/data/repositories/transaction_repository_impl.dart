import 'package:dartz/dartz.dart';
import 'package:fiscal/core/error/exceptions.dart';
import 'package:fiscal/core/error/failure.dart';
import 'package:fiscal/data/datasources/local/transaction_local_data_source.dart';
import 'package:fiscal/data/datasources/remote/transaction_remote_data_source.dart';
import 'package:fiscal/data/models/models.dart';
import 'package:fiscal/domain/enitities/transactions/transaction.dart';
import 'package:fiscal/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, Map<String, List<Transaction>>>> getAllTransactions(String lastFetchedTransactionID, String time,
      [int batchSize = 10]) async {
    try {
      final transactions = await remoteDataSource.getAllTransactions(lastFetchedTransactionID, time, batchSize);
      return Right(transactions);
    } on DataException catch (d) {
      return Left(DataFailure(message: d.message));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getRecentTransactions() async {
    try {
      final transactions = await localDataSource.getRecentTransactions();

      if (transactions.isNotEmpty) return Right(transactions);

      // no cache present. hit database.
      final dbTransactions = await remoteDataSource.getRecentTransactions();
      await localDataSource.cacheRecentTransactions(dbTransactions);

      return Right(dbTransactions);
    } on DataException catch (d) {
      //TODO add logs
      return Left(DataFailure(message: d.message));
    } on CacheException catch (c) {
      //TODO add logs
      return Left(CacheFailure(message: c.message));
    }
  }

  @override
  Future<Either<Failure, String>> addNewTransaction(Transaction transaction) async {
    try {
      final transactionModel = TransactionModel.fromTransaction(transaction);
      final rows = await remoteDataSource.addNewTransaction(transactionModel);
      await localDataSource.cacheNewTransaction(transactionModel);
      return Right(rows);
    } on DataException catch (d) {
      return Left(DataFailure(message: d.message));
    }
  }
}
