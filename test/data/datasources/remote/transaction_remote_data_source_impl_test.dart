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
import 'database.mocks.dart';
import 'transaction_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<Database>(returnNullOnMissingStub: true),
  MockSpec<DatabaseExecutor>(returnNullOnMissingStub: true),
])
void main() {
  late TransactionRemoteDataSourceImpl dataSourceImpl;
  late MockDatabase mockDatabase;
  late DatabaseMock databaseMock;

  setUp(() {
    mockDatabase = MockDatabase();
    databaseMock = DatabaseMock();
    dataSourceImpl = TransactionRemoteDataSourceImpl(db: databaseMock);
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
      when(databaseMock.rawQuery(query, ['', time, batchSize])).thenAnswer((_) async => queryResult);
      //act
      final result = await dataSourceImpl.getAllTransactions('', time);
      //assert
      verify(databaseMock.rawQuery(query, [batchSize]));
      expect(result, {'data': transactions});
    });

    test('should fetch paginated transactions for subsequent load and specified batch size', () async {
      // arrange
      String paginatedQuery = 'SELECT * FROM ${TransactionTable.TABLE_NAME} WHERE ${TransactionTable.date} like ? and  '
          '${TransactionTable.id} < ? ORDER BY'
          ' ${TransactionTable.id} DESC LIMIT ?';
      when(databaseMock.rawQuery(paginatedQuery, [time, lastFetchedTransactionID, batchSize]))
          .thenAnswer((_) async => queryResult);
      //act
      final result = await dataSourceImpl.getAllTransactions(lastFetchedTransactionID, time);
      //assert
      verify(databaseMock.rawQuery(paginatedQuery, [time, lastFetchedTransactionID, batchSize]));
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
      when(databaseMock.rawQuery(query, [10])).thenAnswer((_) async => queryResult);
      //act
      final result = await dataSourceImpl.getRecentTransactions();
      //assert
      verify(databaseMock.rawQuery(query, [10]));
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
    String lastInsertedRowIDQuery = 'select last_insert_rowid();';
    final List<Map<String, Object?>> lastInsertedRowResult = [
      {'last_insert_rowid()': 1}
    ];

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

    test('should add new transaction to the database and return inserted row ID', () async {
      // arrange
      int transactionID = 1;
      when(databaseMock.insert(TransactionTable.TABLE_NAME, TransactionModel.toQuery(transaction)))
          .thenAnswer((_) async => transactionID);
      when(databaseMock.rawQuery(lastInsertedRowIDQuery)).thenAnswer((_) async => lastInsertedRowResult);
      //act
      final result = await dataSourceImpl.addNewTransaction(transaction);
      //assert
      verify(databaseMock.insert(
        TransactionTable.TABLE_NAME,
        TransactionModel.toQuery(transaction),
        conflictAlgorithm: ConflictAlgorithm.fail,
      ));
      verify(databaseMock.rawQuery(lastInsertedRowIDQuery));
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
      when(databaseMock.insert(TransactionTable.TABLE_NAME, TransactionModel.toQuery(transaction))).thenAnswer((_) async => 0);
      //act
      final call = dataSourceImpl.addNewTransaction;
      //assert
      expect(() => call(transaction), throwsA(TypeMatcher<DataException>()));
    });
  });

  group('getDailySummary', () {
    Map<String, Object?> dbResult = {'transaction_type': 'EXPENSE', 'amount': 7316.0};
    Map<String, Object?> summary = {'EXPENSE': 7316.0};
    // final String query = ''
    //     'SELECT SUM(amount)'
    //     'FROM ${TransactionTable.TABLE_NAME} '
    //     'GROUP BY ${TransactionTable.transaction_type} '
    //     'WHERE ${TransactionTable.date}=DATE()';
    final String query = ''
        'SELECT ${TransactionTable.transaction_type}, SUM(amount) AS amount '
        'FROM ${TransactionTable.TABLE_NAME} '
        // 'WHERE ${TransactionTable.date}=DATE() '
        'GROUP BY ${TransactionTable.transaction_type}';
    final rows = [dbResult];

    test('should get daily summary data for current day', () async {
      // arrange
      when(databaseMock.rawQuery(query)).thenAnswer((_) async => rows);
      //act
      final result = await dataSourceImpl.getDailySummary();
      //assert
      verify(databaseMock.rawQuery(query, [10]));
      expect(result, summary);
    });

    test('should return 0 value as summary when no records are present', () async {
      // arrange
      when(databaseMock.rawQuery(query)).thenAnswer((_) async => []);
      //act
      final expectedResult = {'EXPENSE': 0.0, 'INCOME': 0.0};
      final result = await dataSourceImpl.getDailySummary();
      //assert
      verify(databaseMock.rawQuery(query, [10]));
      expect(result, expectedResult);
    });

    test('should throw DataException when adding data fails', () async {
      //act
      final call = dataSourceImpl.getDailySummary;
      //assert
      expect(() => call(), throwsA(TypeMatcher<DataException>()));
    });
  });
}
