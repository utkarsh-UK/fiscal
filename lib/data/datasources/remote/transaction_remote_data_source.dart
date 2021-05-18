import 'package:fiscal/core/error/exceptions.dart';
import 'package:fiscal/core/utils/tables/transaction_table.dart';
import 'package:fiscal/data/models/models.dart';
import 'package:sqflite/sqflite.dart';

abstract class TransactionRemoteDataSource {
  Future<List<TransactionModel>> getRecentTransactions();

  Future<Map<String, List<TransactionModel>>> getAllTransactions(String lastFetchedTransactionID, [int batchSize = 10]);

  Future<String> addNewTransaction(TransactionModel transaction);
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final Database db;

  TransactionRemoteDataSourceImpl({required this.db});

  @override
  Future<Map<String, List<TransactionModel>>> getAllTransactions(String lastFetchedTransactionID, [int batchSize = 10]) async {
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
  Future<List<TransactionModel>> getRecentTransactions() async {
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

  @override
  Future<String> addNewTransaction(TransactionModel transaction) async {
    try {
      final int id = await db.insert(TransactionTable.TABLE_NAME, TransactionModel.toQuery(transaction));

      return '$id';
    } catch (e) {
      throw DataException(message: e.toString());
    }
  }
}
