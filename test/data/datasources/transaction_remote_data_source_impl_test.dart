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

import '../../fixtures/transactions/transaction.dart';
import 'transaction_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([Database])
void main() {
  late TransactionRemoteDataSourceImpl dataSourceImpl;
  late MockDatabase mockDatabase;

  setUp(() {
    mockDatabase = MockDatabase();
    dataSourceImpl = TransactionRemoteDataSourceImpl(db: mockDatabase);
  });

  group('getAllTransactions', () {
    String lastFetchedTransactionID = 'id';
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
      String query = 'SELECT * FROM ${TransactionTable.TABLE_NAME} ORDER BY'
          ' ${TransactionTable.id} DESC LIMIT ?';
      when(mockDatabase.rawQuery(query, ['', batchSize])).thenAnswer((_) async => queryResult);
      //act
      final result = await dataSourceImpl.getAllTransactions('');
      //assert
      verify(mockDatabase.rawQuery(query, [batchSize]));
      expect(result, {'data': transactions});
    });

    test('should fetch paginated transactions for subsequent load and specified batch size', () async {
      // arrange
      String paginatedQuery = 'SELECT * FROM ${TransactionTable.TABLE_NAME} where ${TransactionTable.id} < ? ORDER BY'
          ' ${TransactionTable.id} DESC LIMIT ?';
      when(mockDatabase.rawQuery(paginatedQuery, [lastFetchedTransactionID, batchSize])).thenAnswer((_) async => queryResult);
      //act
      final result = await dataSourceImpl.getAllTransactions(lastFetchedTransactionID);
      //assert
      verify(mockDatabase.rawQuery(paginatedQuery, [lastFetchedTransactionID, batchSize]));
      expect(result, {'data': transactions});
    });

    test('should throw DataException when fetching data fails', () async {
      //act
      final call = dataSourceImpl.getAllTransactions;
      //assert
      expect(() => call(lastFetchedTransactionID), throwsA(TypeMatcher<DataException>()));
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
}
