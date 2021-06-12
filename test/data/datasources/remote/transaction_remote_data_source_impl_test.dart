import 'package:fiscal/core/core.dart';
import 'package:fiscal/core/error/exceptions.dart';
import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/data/datasources/remote/transaction_remote_data_source.dart';
import 'package:fiscal/data/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

import '../../../fixtures/transactions/transaction.dart';
import 'transaction_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([Database, DatabaseExecutor])
void main() {
  late TransactionRemoteDataSourceImpl dataSourceImpl;
  late MockDatabase mockDatabase;

  setUp(() {
    mockDatabase = MockDatabase();
    dataSourceImpl = TransactionRemoteDataSourceImpl(db: mockDatabase);
  });

  group('getAllTransactions', () {
    String lastFetchedTransactionID = 'id';
    String time = '2021-05-14%';
    int batchSize = 10;

    List<Map<String, Object?>> queryResult = [transactionQuery];
    final DateTime date = DateTime(2021, 05, 14, 14, 13, 29, 104);
    final transactions = [
      TransactionModel(
          transactionID: 'id',
          title: 'title',
          amount: 10.10,
          transactionType: TransactionType.INCOME,
          categoryID: 'category',
          accountID: 1,
          date: date,
          description: 'desc')
    ];

    test('should fetch all transactions for initial load and specified batch size', () async {
      // arrange
      String query = 'SELECT * FROM ${TransactionTable.TABLE_NAME} WHERE ${TransactionTable.date} like ? ORDER BY'
          ' ${TransactionTable.id} DESC LIMIT ?';
      when(mockDatabase.rawQuery(query, ['', time, batchSize])).thenAnswer((_) async => queryResult);
      //act
      final result = await dataSourceImpl.getAllTransactions('', time);
      //assert
      verify(mockDatabase.rawQuery(query, [batchSize]));
      expect(result, {'data': transactions});
    });

    test('should fetch paginated transactions for subsequent load and specified batch size', () async {
      // arrange
      String paginatedQuery = 'SELECT * FROM ${TransactionTable.TABLE_NAME} WHERE ${TransactionTable.date} like ? and  '
          '${TransactionTable.id} < ? ORDER BY'
          ' ${TransactionTable.id} DESC LIMIT ?';
      when(mockDatabase.rawQuery(paginatedQuery, [time, lastFetchedTransactionID, batchSize]))
          .thenAnswer((_) async => queryResult);
      //act
      final result = await dataSourceImpl.getAllTransactions(lastFetchedTransactionID, time);
      //assert
      verify(mockDatabase.rawQuery(paginatedQuery, [time, lastFetchedTransactionID, batchSize]));
      expect(result, {'data': transactions});
    });

    test('should throw DataException when fetching data fails', () async {
      //act
      final call = dataSourceImpl.getAllTransactions;
      //assert
      expect(() => call(lastFetchedTransactionID, time), throwsA(TypeMatcher<DataException>()));
    });
  });

  group('getRecentTransactions', () {
    String query = 'SELECT * FROM ${TransactionTable.TABLE_NAME} ORDER BY'
        ' ${TransactionTable.id} DESC LIMIT ?';

    List<Map<String, Object?>> queryResult = [transactionQuery];
    final DateTime date = DateTime(2021, 05, 14, 14, 13, 29, 104);
    final transactions = [
      TransactionModel(
          transactionID: 'id',
          title: 'title',
          amount: 10.10,
          transactionType: TransactionType.INCOME,
          categoryID: 'category',
          accountID: 1,
          date: date,
          description: 'desc')
    ];

    test('should fetch recent transactions from database', () async {
      // arrange
      when(mockDatabase.rawQuery(query, [10])).thenAnswer((_) async => queryResult);
      //act
      final result = await dataSourceImpl.getRecentTransactions();
      //assert
      verify(mockDatabase.rawQuery(query, [10]));
      expect(result, transactions);
    });

    test('should throw DataException when fetching data fails', () async {
      //act
      final call = dataSourceImpl.getRecentTransactions;
      //assert
      expect(() => call(), throwsA(TypeMatcher<DataException>()));
    });
  });

  group('addNewTransaction', () {
    String query = 'INSERT INTO ${TransactionTable.TABLE_NAME} VALUES (?, ?, ?, ?, ?, ?, ?, ?)';

    final DateTime date = DateTime(2021, 05, 14, 14, 13, 29, 104);
    final transaction = TransactionModel(
        transactionID: 'id',
        title: 'title',
        amount: 10.10,
        transactionType: TransactionType.INCOME,
        categoryID: 'category',
        accountID: 1,
        date: date,
        description: 'desc');

    test('should add new transaction to the database and return row count', () async {
      // arrange
      int transactionID = 1;
      when(mockDatabase.insert(TransactionTable.TABLE_NAME, TransactionModel.toQuery(transaction)))
          .thenAnswer((_) async => transactionID);
      //act
      final result = await dataSourceImpl.addNewTransaction(transaction);
      //assert
      verify(mockDatabase.rawQuery(query, [10]));
      expect(result, '$transactionID');
    });

    test('should throw DataException when adding data fails', () async {
      //act
      final call = dataSourceImpl.addNewTransaction;
      //assert
      expect(() => call(transaction), throwsA(TypeMatcher<DataException>()));
    });

    test('should throw DataException when insert returns 0 row count.', () async {
      // arrange
      when(mockDatabase.insert(TransactionTable.TABLE_NAME, TransactionModel.toQuery(transaction))).thenAnswer((_) async => 0);
      //act
      final call = dataSourceImpl.addNewTransaction;
      //assert
      expect(() => call(transaction), throwsA(TypeMatcher<DataException>()));
    });
  });
}
