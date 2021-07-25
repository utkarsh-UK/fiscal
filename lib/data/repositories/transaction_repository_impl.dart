import 'package:dartz/dartz.dart';
import 'package:f_logs/f_logs.dart';
import 'package:fiscal/core/error/exceptions.dart';
import 'package:fiscal/core/error/failure.dart';
import 'package:fiscal/core/utils/helpers/converters.dart';
import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/data/datasources/local/transaction_local_data_source.dart';
import 'package:fiscal/data/datasources/remote/transaction_remote_data_source.dart';
import 'package:fiscal/data/models/models.dart';
import 'package:fiscal/domain/enitities/core/category.dart';
import 'package:fiscal/domain/enitities/transactions/transaction.dart';
import 'package:fiscal/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  static const String CLASS_NAME = 'TransactionRepositoryImpl';

  final TransactionRemoteDataSource remoteDataSource;
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, Map<String, List<Transaction>>>> getAllTransactions(String lastFetchedTransactionID, String time,
      [int batchSize = 10]) async {
    FLog.info(text: 'Enter', className: CLASS_NAME, methodName: 'getAllTransactions()');

    try {
      final transactions = await remoteDataSource.getAllTransactions(lastFetchedTransactionID, time, batchSize);
      FLog.info(text: 'Fetched transactions from data source', className: CLASS_NAME, methodName: 'getAllTransactions()');
      FLog.info(text: 'Exit', className: CLASS_NAME, methodName: 'getAllTransactions()');
      return Right(transactions);
    } on DataException catch (d) {
      FLog.error(text: 'Error Repo: ${d.message}', className: CLASS_NAME, methodName: 'getAllTransactions()');
      return Left(DataFailure(message: d.message));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getRecentTransactions() async {
    FLog.info(text: 'Enter', className: CLASS_NAME, methodName: 'getRecentTransactions()');

    try {
      final transactions = await localDataSource.getRecentTransactions();

      if (transactions.isNotEmpty) {
        FLog.info(
          text: '${transactions.length} transactions in cache',
          className: CLASS_NAME,
          methodName: 'getRecentTransactions()',
        );
        FLog.info(text: 'Exit', className: CLASS_NAME, methodName: 'getRecentTransactions()');
        return Right(transactions);
      }

      // no cache present. hit database.
      final dbTransactions = await remoteDataSource.getRecentTransactions();
      await localDataSource.cacheRecentTransactions(dbTransactions);
      FLog.info(
        text: 'Cached ${dbTransactions.length} transactions in [Recent] cache',
        className: CLASS_NAME,
        methodName: 'getRecentTransactions()',
      );
      FLog.info(text: 'Exit', className: CLASS_NAME, methodName: 'getRecentTransactions()');

      return Right(dbTransactions);
    } on DataException catch (d) {
      FLog.error(text: 'Error Repo: ${d.message}', className: CLASS_NAME, methodName: 'getRecentTransactions()');
      return Left(DataFailure(message: d.message));
    } on CacheException catch (c) {
      FLog.error(text: 'Error Repo: ${c.message}', className: CLASS_NAME, methodName: 'getRecentTransactions()');
      return Left(CacheFailure(message: c.message));
    }
  }

  @override
  Future<Either<Failure, String>> addNewTransaction(Transaction transaction) async {
    FLog.info(text: 'Enter', className: CLASS_NAME, methodName: 'addNewTransaction()');

    try {
      final transactionModel = TransactionModel.fromTransaction(transaction);
      final transactionID = await remoteDataSource.addNewTransaction(transactionModel);

      final transactionModelWithID = TransactionModel.fromTransaction(transaction, id: transactionID);
      await localDataSource.cacheNewTransaction(transactionModelWithID);

      FLog.info(
        text: 'Added new transaction. ID: [$transactionID], AMOUNT: [${transaction.amount}]',
        className: CLASS_NAME,
        methodName: 'addNewTransaction()',
      );
      FLog.info(text: 'Exit', className: CLASS_NAME, methodName: 'addNewTransaction()');

      return Right(transactionID);
    } on DataException catch (d) {
      FLog.error(text: 'Error Repo: ${d.message}', className: CLASS_NAME, methodName: 'addNewTransaction()');
      return Left(DataFailure(message: d.message));
    }
  }

  @override
  Future<Either<Failure, Map<String, Object?>>> getDailySummary() async {
    try {
      FLog.info(text: 'Enter', className: CLASS_NAME, methodName: 'addNewTransaction()');

      final summary = await remoteDataSource.getDailySummary();

      FLog.info(
        text: 'Fetched summary from data source.',
        className: CLASS_NAME,
        methodName: 'getDailySummary()',
      );
      FLog.info(text: 'Exit', className: CLASS_NAME, methodName: 'getDailySummary()');

      return Right(summary);
    } on DataException catch (d) {
      FLog.error(text: 'Error Repo: ${d.message}', className: CLASS_NAME, methodName: 'getDailySummary()');
      return Left(DataFailure(message: d.message));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getCategories(TransactionType type) async {
    try {
      FLog.info(text: 'Enter', className: CLASS_NAME, methodName: 'getCategories()');

      final convertedType = Converters.convertTransactionTypeEnum(type);
      final categories = await remoteDataSource.getCategories(convertedType);

      FLog.info(
        text: 'Fetched ${categories.length} from database for $type.',
        className: CLASS_NAME,
        methodName: 'getCategories()',
      );
      FLog.info(text: 'Exit', className: CLASS_NAME, methodName: 'getCategories()');

      return Right(categories);
    } on DataException catch (d) {
      FLog.error(text: 'Error Repo: ${d.message}', className: CLASS_NAME, methodName: 'getCategories()');
      return Left(DataFailure(message: d.message));
    }
  }

  @override
  Future<Either<Failure, String>> updateTransaction(Transaction transaction) {
    // TODO: implement updateTransaction
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> deleteTransaction(int transactionID) async {
    FLog.info(text: 'Enter', className: CLASS_NAME, methodName: 'deleteTransaction()');

    try {
      final result = await remoteDataSource.deleteTransaction(transactionID);

      FLog.info(
        text: 'Deleted transaction. ID: [$transactionID]',
        className: CLASS_NAME,
        methodName: 'deleteTransaction()',
      );
      FLog.info(text: 'Exit', className: CLASS_NAME, methodName: 'deleteTransaction()');

      return Right(result);
    } on DataException catch (d) {
      FLog.error(text: 'Error Repo: ${d.message}', className: CLASS_NAME, methodName: 'deleteTransaction()');
      return Left(DataFailure(message: d.message));
    }
  }
}
