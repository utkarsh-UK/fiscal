import 'package:fiscal/core/error/exceptions.dart';
import 'package:fiscal/core/utils/tables/transaction_table.dart';
import 'package:fiscal/data/models/models.dart';
import 'package:fiscal/domain/enitities/transactions/transaction.dart' as t;
import 'package:sqflite/sqflite.dart';

abstract class TransactionRemoteDataSource {
  Future<List<t.Transaction>> getRecentTransactions();

  Future<Map<String, List<t.Transaction>>> getAllTransactions(String lastFetchedTransactionID, [int batchSize = 10]);
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final Database db;

  TransactionRemoteDataSourceImpl({required this.db});

  @override
  Future<Map<String, List<t.Transaction>>> getAllTransactions(String lastFetchedTransactionID, [int batchSize = 10]) async {
    try {
      late List<Map<String, Object?>> queryData;
      if (lastFetchedTransactionID.isEmpty) {
        //initial fetch request
        queryData = await db.rawQuery(
          'SELECT * FROM ${TransactionTable.TABLE_NAME}  ORDER BY'
          ' ${TransactionTable.id} DESC LIMIT ?',
          [batchSize],
        );
      } else {
        //subsequent fetch request
        queryData = await db.rawQuery(
          'SELECT * FROM ${TransactionTable.TABLE_NAME} where ${TransactionTable.id} < ? ORDER BY'
          ' ${TransactionTable.id} DESC LIMIT ?'
          '',
          [lastFetchedTransactionID, batchSize],
        );
      }

      final queryList = queryData.map((transaction) => TransactionModel.fromQueryResult(transaction)).toList();
      return {'data': queryList};
    } catch (e) {
      throw DataException(message: e.toString());
    }
  }

  @override
  Future<List<t.Transaction>> getRecentTransactions() async {
    try {
      final queryData = await db.rawQuery(
        'SELECT * FROM ${TransactionTable.TABLE_NAME}  ORDER BY'
        ' ${TransactionTable.id} DESC LIMIT ?'
        '',
        [10],
      );

      final queryList = queryData.map((transaction) => TransactionModel.fromQueryResult(transaction)).toList();
      return queryList;
    } catch (e) {
      throw DataException(message: e.toString());
    }
  }
}
