import 'package:f_logs/f_logs.dart';
import 'package:fiscal/core/error/exceptions.dart';
import 'package:fiscal/core/utils/tables/category_table.dart';
import 'package:fiscal/core/utils/tables/transaction_table.dart';
import 'package:fiscal/data/models/models.dart';
import 'package:sqflite/sqflite.dart';

abstract class TransactionRemoteDataSource {
  /// Fetches 10 most recent transactions.
  ///
  /// Method calls [LocalDataSource] for cached transactions. If
  /// no cache present, then gets the data from [RemoteDataSource].
  Future<List<TransactionModel>> getRecentTransactions();

  /// Fetches paginated transactions for given [batchSize].
  ///
  /// If [lastFetchedTransactionID] is empty, it's treated as initial hit.
  /// Else, returns all the records after [lastFetchedTransactionID] row.
  Future<Map<String, List<TransactionModel>>> getAllTransactions(String lastFetchedTransactionID, String time,
      [int batchSize = 10]);

  /// Adds new transaction to database and cached this [transaction]
  /// into local cache.
  Future<String> addNewTransaction(TransactionModel transaction);

  /// Fetch monthly summary for current month.
  Future<Map<String, Object?>> getDailySummary();

  /// Fetches all categories for [type] transaction.
  Future<List<CategoryModel>> getCategories(String type);
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
          ['$time%', batchSize],
        );
      } else {
        //subsequent fetch request
        queryData = await db.rawQuery(
          'SELECT * FROM ${TransactionTable.TABLE_NAME} WHERE ${TransactionTable.date} like ? and ${TransactionTable.id} < ? '
          'ORDER BY'
          ' ${TransactionTable.id} DESC LIMIT ?'
          '',
          ['$time%', lastFetchedTransactionID, batchSize],
        );
      }
      final queryList = queryData.map((transaction) => TransactionModel.fromQueryResult(transaction)).toList()
        ..sort((a, b) => b.date.compareTo(a.date));

      FLog.info(
        text:
            'Fetched ${queryData.toString()} ${queryList.length} transactions for [lastTransactionID: $lastFetchedTransactionID] from '
            'database',
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
      //TODO Add date later for current day's summary
      final String query = ''
          'SELECT ${TransactionTable.transaction_type}, SUM(amount) AS amount '
          'FROM ${TransactionTable.TABLE_NAME} '
          // 'WHERE ${TransactionTable.date}=DATE() '
          'GROUP BY ${TransactionTable.transaction_type}';
      final results = await db.rawQuery(query);

      if (results.isEmpty) {
        FLog.warning(
          text: 'Returned empty results. Might have no transactions for current month or candidate for future issue.',
          className: CLASS_NAME,
          methodName: 'getDailySummary()',
        );

        return {'EXPENSE': 0.0, 'INCOME': 0.0};
      }

      FLog.info(
        text: 'Fetched daily summary ${results.toString()}',
        className: CLASS_NAME,
        methodName: 'getDailySummary()',
      );

      Map<String, Object?> data = {};
      double amount1 = num.parse('${results.first['amount'] ?? 0.0}').toDouble();
      data.putIfAbsent('${results.first[TransactionTable.transaction_type]}', () => amount1);

      if (results.length > 1) {
        double amount2 = num.parse('${results[1]['amount'] ?? 0.0}').toDouble();
        data.putIfAbsent('${results[1][TransactionTable.transaction_type]}', () => amount2);
      }

      FLog.info(text: 'Exit', className: CLASS_NAME, methodName: 'getDailySummary()');

      return data;
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

  @override
  Future<List<CategoryModel>> getCategories(String type) async {
    FLog.info(text: 'Enter', className: CLASS_NAME, methodName: 'getCategories()');

    try {
      final queryData = await db.rawQuery(
        'SELECT * FROM ${CategoryTable.TABLE_NAME} WHERE ${CategoryTable.transactionType}=?',
        [type],
      );

      final queryList = queryData.map((category) => CategoryModel.fromQueryResult(category)).toList();

      FLog.info(
        text: 'Fetched ${queryList.length} categories from database',
        className: CLASS_NAME,
        methodName: 'getCategories()',
      );
      FLog.info(text: 'Exit', className: CLASS_NAME, methodName: 'getCategories()');

      return queryList;
    } catch (e, trace) {
      FLog.error(
        text: 'Exception occurred: $type',
        className: CLASS_NAME,
        methodName: 'getCategories()',
        exception: e,
        stacktrace: trace,
      );
      throw DataException(message: e.toString());
    }
  }
}
