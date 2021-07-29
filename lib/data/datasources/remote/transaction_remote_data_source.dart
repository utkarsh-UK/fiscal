import 'package:f_logs/f_logs.dart';
import 'package:fiscal/core/error/exceptions.dart';
import 'package:fiscal/core/utils/tables/accounts_table.dart';
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

  /// Updates transaction with this [transaction] and returns updated transaction.
  Future<Map<String, Object>> updateTransaction(TransactionModel transaction);

  /// Deletes transaction with this [transactionID].
  Future<bool> deleteTransaction(int transactionID);

  /// Fetch monthly summary for current month.
  Future<Map<String, Object?>> getDailySummary();

  /// Fetches all categories for [type] transaction.
  Future<List<CategoryModel>> getCategories(String type);

  /// Fetches all accounts.
  Future<List<AccountModel>> getAccounts();
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
          'SELECT t.*, c.${CategoryTable.icon}, c.${CategoryTable.color} '
          'FROM ${TransactionTable.TABLE_NAME} t '
          'JOIN ${CategoryTable.TABLE_NAME} c ON c.${CategoryTable.id}=t.${TransactionTable.category_id} '
          'WHERE ${TransactionTable.date} like ? '
          'ORDER BY '
          '${TransactionTable.id} DESC LIMIT ?',
          ['$time%', batchSize],
        );
      } else {
        //subsequent fetch request
        queryData = await db.rawQuery(
          'SELECT t.*, c.${CategoryTable.icon}, c.${CategoryTable.color} '
          'FROM ${TransactionTable.TABLE_NAME} t '
          'JOIN ${CategoryTable.TABLE_NAME} c ON c.${CategoryTable.id}=t.${TransactionTable.category_id} '
          'WHERE ${TransactionTable.date} like ? and ${TransactionTable.id} < ? '
          'ORDER BY'
          ' ${TransactionTable.id} DESC LIMIT ?',
          ['$time%', lastFetchedTransactionID, batchSize],
        );
      }
      final queryList = queryData.map((transaction) => TransactionModel.fromQueryResult(transaction)).toList()
        ..sort((a, b) => b.date.compareTo(a.date));

      FLog.info(
        text: 'Fetched ${queryList.length} transactions for [lastTransactionID: $lastFetchedTransactionID] from '
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
        'SELECT t.*, c.${CategoryTable.icon}, c.${CategoryTable.color} '
        'FROM ${TransactionTable.TABLE_NAME} t '
        'JOIN ${CategoryTable.TABLE_NAME} c ON c.${CategoryTable.id}=t.${TransactionTable.category_id} '
        'ORDER BY ${TransactionTable.id} DESC LIMIT ?',
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

  @override
  Future<bool> deleteTransaction(int transactionID) async {
    FLog.info(text: 'Enter', className: CLASS_NAME, methodName: 'deleteTransaction()');

    try {
      final result = await db.delete(
        TransactionTable.TABLE_NAME,
        where: '${TransactionTable.id}=?',
        whereArgs: [transactionID],
      );
      final bool isDeleted = result > 0;

      FLog.info(
        text: !isDeleted ? 'Could not delete transaction. ID: [$transactionID]' : 'Deleted transaction. ID: [$transactionID]',
        className: CLASS_NAME,
        methodName: 'deleteTransaction()',
      );
      FLog.info(text: 'Exit', className: CLASS_NAME, methodName: 'deleteTransaction()');

      return isDeleted;
    } catch (e, trace) {
      FLog.error(
        text: 'Exception occurred: $transactionID',
        className: CLASS_NAME,
        methodName: 'deleteTransaction()',
        exception: e,
        stacktrace: trace,
      );
      throw DataException(message: e.toString());
    }
  }

  @override
  Future<Map<String, Object>> updateTransaction(TransactionModel transaction) async {
    TransactionModel? updatedModel;
    FLog.info(text: 'Enter', className: CLASS_NAME, methodName: 'updateTransaction()');

    try {
      final int transactionID = num.tryParse(transaction.transactionID)?.toInt() ?? -1;
      final result = await db.update(
        TransactionTable.TABLE_NAME,
        TransactionModel.toQuery(transaction),
        where: '${TransactionTable.id}=?',
        whereArgs: [transactionID],
      );
      final bool isUpdated = result > 0;
      if (isUpdated) {
        final updatedRow = await db.rawQuery(
            'SELECT t.*, c.${CategoryTable.icon}, c.${CategoryTable.color} '
            'FROM ${TransactionTable.TABLE_NAME} t '
            'JOIN ${CategoryTable.TABLE_NAME} c ON c.${CategoryTable.id}=t.${TransactionTable.category_id} '
            'WHERE ${TransactionTable.id}=?',
            [transactionID]);
        updatedModel = TransactionModel.fromQueryResult(updatedRow.first);
      }

      FLog.info(
        text: !isUpdated ? 'Could not update transaction. ID: [$transactionID]' : 'Updated transaction. ID: [$transactionID]',
        className: CLASS_NAME,
        methodName: 'updateTransaction()',
      );
      FLog.info(text: 'Exit', className: CLASS_NAME, methodName: 'updateTransaction()');

      return {'isUpdated': isUpdated, 'transaction': updatedModel ?? transaction};
    } catch (e, trace) {
      FLog.error(
        text: 'Exception occurred: ${transaction.transactionID}',
        className: CLASS_NAME,
        methodName: 'updateTransaction()',
        exception: e,
        stacktrace: trace,
      );
      throw DataException(message: e.toString());
    }
  }

  @override
  Future<List<AccountModel>> getAccounts() async {
    FLog.info(text: 'Enter', className: CLASS_NAME, methodName: 'getAccounts()');

    try {
      final queryData = await db.rawQuery('SELECT * FROM ${AccountsTable.TABLE_NAME};');

      final queryList = queryData.map((account) => AccountModel.fromQueryResult(account)).toList();

      FLog.info(
        text: 'Fetched ${queryList.length} categories from database',
        className: CLASS_NAME,
        methodName: 'getAccounts()',
      );
      FLog.info(text: 'Exit', className: CLASS_NAME, methodName: 'getAccounts()');

      return queryList;
    } catch (e, trace) {
      FLog.error(
        text: 'Exception occurred:',
        className: CLASS_NAME,
        methodName: 'getAccounts()',
        exception: e,
        stacktrace: trace,
      );
      throw DataException(message: e.toString());
    }
  }
}
