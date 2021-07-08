import 'package:f_logs/f_logs.dart';
import 'package:fiscal/core/error/exceptions.dart';
import 'package:fiscal/core/utils/tables/transaction_table.dart';
import 'package:fiscal/data/models/models.dart';
import 'package:sqflite/sqflite.dart';

abstract class TransactionRemoteDataSource {
  Future<List<TransactionModel>> getRecentTransactions();

  /// Fetches paginated transactions for given [batchSize].
  ///
  /// If [lastFetchedTransactionID] is empty, it's treated as initial hit.
  /// Else, returns all the records after [lastFetchedTransactionID] row.
  Future<Map<String, List<TransactionModel>>> getAllTransactions(String lastFetchedTransactionID, String time,
      [int batchSize = 10]);

  Future<String> addNewTransaction(TransactionModel transaction);

  Future<Map<String, Object?>> getDailySummary();
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  static const String CLASS_NAME = 'TransactionRemoteDataSourceImpl';

  final Database db;

  TransactionRemoteDataSourceImpl({required this.db});

  @override
  Future<Map<String, List<TransactionModel>>> getAllTransactions(String lastFetchedTransactionID, String time,
      [int batchSize = 10]) async {
    FLog.info(text: 'Enter', className: CLASS_NAME, methodName: 'getAllTransactions()');

    try {
      late List<Map<String, Object?>> queryData;
      if (lastFetchedTransactionID.isEmpty) {
        //initial fetch request
        queryData = await db.rawQuery(
          'SELECT * FROM ${TransactionTable.TABLE_NAME} WHERE ${TransactionTable.date} like ?  ORDER BY'
          ' ${TransactionTable.id} DESC LIMIT ?',
          [time, batchSize],
        );
      } else {
        //subsequent fetch request
        queryData = await db.rawQuery(
          'SELECT * FROM ${TransactionTable.TABLE_NAME} WHERE ${TransactionTable.date} like ? and ${TransactionTable.id} < ? '
          'ORDER BY'
          ' ${TransactionTable.id} DESC LIMIT ?'
          '',
          [time, lastFetchedTransactionID, batchSize],
        );
      }
      final queryList = queryData.map((transaction) => TransactionModel.fromQueryResult(transaction)).toList();

      FLog.info(
        text: 'Fetched ${queryList.length} transactions for [lastTransactionID: $lastFetchedTransactionID] from database',
        className: CLASS_NAME,
        methodName: 'getAllTransactions()',
      );
      FLog.info(text: 'Exit', className: CLASS_NAME, methodName: 'getAllTransactions()');

      return {'data': queryList};
    } catch (e, trace) {
      FLog.error(
        text: 'Exception occurred: Might be due to wrong transaction ID or bad query',
        className: CLASS_NAME,
        methodName: 'getAllTransactions()',
        exception: e,
        stacktrace: trace,
      );
      throw DataException(message: e.toString());
    }
  }

  @override
  Future<List<TransactionModel>> getRecentTransactions() async {
    FLog.info(text: 'Enter', className: CLASS_NAME, methodName: 'getRecentTransactions()');

    try {
      final queryData = await db.rawQuery(
        'SELECT * FROM ${TransactionTable.TABLE_NAME}  ORDER BY'
        ' ${TransactionTable.id} DESC LIMIT ?'
        '',
        [10],
      );

      final queryList = queryData.map((transaction) => TransactionModel.fromQueryResult(transaction)).toList();

      FLog.info(
        text: 'Fetched ${queryList.length} transactions from database',
        className: CLASS_NAME,
        methodName: 'getRecentTransactions()',
      );
      FLog.info(text: 'Exit', className: CLASS_NAME, methodName: 'getRecentTransactions()');

      return queryList;
    } catch (e, trace) {
      FLog.error(
        text: 'Exception occurred: Might be due to wrong transaction ID or bad query',
        className: CLASS_NAME,
        methodName: 'getRecentTransactions()',
        exception: e,
        stacktrace: trace,
      );
      throw DataException(message: e.toString());
    }
  }

  @override
  Future<String> addNewTransaction(TransactionModel transaction) async {
    FLog.info(text: 'Enter', className: CLASS_NAME, methodName: 'addNewTransaction()');

    try {
      final int rowCount = await db.insert(
        TransactionTable.TABLE_NAME,
        TransactionModel.toQuery(transaction),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );

      if (rowCount == 0) {
        FLog.warning(
          text: 'Could not insert this transaction. Confirm query once.',
          className: CLASS_NAME,
          methodName: 'addNewTransaction()',
        );
        throw DataException(message: 'Could not insert transaction. Please try later');
      }

      final rowID = await db.rawQuery('select last_insert_rowid();');
      if (rowID.isEmpty) {
        FLog.warning(
          text: 'Could not get last inserted row ID. [${transaction.title}]',
          className: CLASS_NAME,
          methodName: 'addNewTransaction()',
        );
        throw DataException(message: 'Could not insert transaction. Please try later');
      }
      int transactionID = int.parse(rowID.first['last_insert_rowid()']!.toString());

      FLog.info(
        text: 'Inserted new transaction. [TransactionID: $transactionID]',
        className: CLASS_NAME,
        methodName: 'addNewTransaction()',
      );
      FLog.info(text: 'Exit', className: CLASS_NAME, methodName: 'addNewTransaction()');

      return '$transactionID';
    } catch (e, trace) {
      FLog.error(
        text: 'Exception occurred: Might be due to wrong transaction ID or bad query',
        className: CLASS_NAME,
        methodName: 'addNewTransaction()',
        exception: e,
        stacktrace: trace,
      );
      throw DataException(message: e.toString());
    }
  }

  @override
  Future<Map<String, Object?>> getDailySummary() async {
    FLog.info(text: 'Enter', className: CLASS_NAME, methodName: 'getDailySummary()');

    try {
      final String query = ''
          'SELECT SUM(amount)'
          'FROM ${TransactionTable.TABLE_NAME} '
          'GROUP BY ${TransactionTable.transaction_type} '
          'WHERE ${TransactionTable.date}=DATE()';
      final results = await db.rawQuery(query);

      if (results.isEmpty) {
        FLog.warning(
          text: 'Returned empty results. Might have no transactions for current month or candidate for future issue.',
          className: CLASS_NAME,
          methodName: 'getDailySummary()',
        );

        throw DataException(message: 'Could not fetch summary.');
      }

      FLog.info(
        text: 'Fetched daily summary',
        className: CLASS_NAME,
        methodName: 'getDailySummary()',
      );
      FLog.info(text: 'Exit', className: CLASS_NAME, methodName: 'getDailySummary()');

      return results.first;
    } catch (e, trace) {
      FLog.error(
        text: 'Exception occurred: Might be due to wrong transaction ID or bad query',
        className: CLASS_NAME,
        methodName: 'getDailySummary()',
        exception: e,
        stacktrace: trace,
      );
      throw DataException(message: e.toString());
    }
  }
}
