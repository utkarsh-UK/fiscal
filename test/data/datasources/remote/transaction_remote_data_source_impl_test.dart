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

@GenerateMocks([], customMocks: [
  MockSpec<Database>(returnNullOnMissingStub: true),
  MockSpec<DatabaseExecutor>(returnNullOnMissingStub: true),
])
void main() {
  late TransactionRemoteDataSourceImpl dataSourceImpl;
  // late MockDatabase mockDatabase;
  late DatabaseMock databaseMock;

  setUp(() {
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
        categoryID: 1,
        accountID: 1,
        date: date,
        description: 'desc',
        category: CategoryModel(categoryID: 1, name: '', color: 'color', icon: 'icon', createdAt: DateTime.now()),
      )
    ];

    test('should fetch all transactions for initial load and specified batch size', () async {
      // arrange
      String query = 'SELECT t.*, c.${CategoryTable.icon}, c.${CategoryTable.color} '
          'FROM ${TransactionTable.TABLE_NAME} t '
          'JOIN ${CategoryTable.TABLE_NAME} c ON c.${CategoryTable.id}=t.${TransactionTable.category_id} '
          'WHERE ${TransactionTable.date} like ? '
          'ORDER BY '
          '${TransactionTable.id} DESC LIMIT ?';
      when(databaseMock.rawQuery(query, [time, batchSize])).thenAnswer((_) async => queryResult);
      //act
      final result = await dataSourceImpl.getAllTransactions('', time);
      //assert
      verify(databaseMock.rawQuery(query, [time, batchSize]));
      expect(result, {'data': transactions});
    });

    test('should fetch paginated transactions for subsequent load and specified batch size', () async {
      // arrange
      String paginatedQuery = 'SELECT t.*, c.${CategoryTable.icon}, c.${CategoryTable.color} '
          'FROM ${TransactionTable.TABLE_NAME} t '
          'JOIN ${CategoryTable.TABLE_NAME} c ON c.${CategoryTable.id}=t.${TransactionTable.category_id} '
          'WHERE ${TransactionTable.date} like ? and ${TransactionTable.id} < ? '
          'ORDER BY'
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
    String query = 'SELECT t.*, c.${CategoryTable.icon}, c.${CategoryTable.color} '
        'FROM ${TransactionTable.TABLE_NAME} t '
        'JOIN ${CategoryTable.TABLE_NAME} c ON c.${CategoryTable.id}=t.${TransactionTable.category_id} '
        'ORDER BY ${TransactionTable.id} DESC LIMIT ?';

    List<Map<String, Object?>> queryResult = [transactionQuery];
    final DateTime date = DateTime(2021, 05, 14, 14, 13, 29, 104);
    final transactions = [
      TransactionModel(
          transactionID: 'id',
          title: 'title',
          amount: 10.10,
          transactionType: TransactionType.INCOME,
          categoryID: 1,
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
        categoryID: 1,
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
      //arrange
      when(databaseMock.rawQuery(lastInsertedRowIDQuery)).thenThrow(Exception());
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

  group('getCategories', () {
    String query = 'SELECT * FROM ${CategoryTable.TABLE_NAME} WHERE ${CategoryTable.transactionType}=?';

    List<Map<String, Object?>> queryResult = [categoryQuery];
    DateTime createdAt = DateTime(2021, 05, 12);
    CategoryModel category =
        CategoryModel(categoryID: 1, name: 'category', icon: 'category', color: 'color', createdAt: createdAt);

    final categories = [category];
    final String type = 'EXPENSE';

    test('should fetch categories from database', () async {
      // arrange
      when(databaseMock.rawQuery(query, ['EXPENSE'])).thenAnswer((_) async => queryResult);
      //act
      final result = await dataSourceImpl.getCategories(type);
      //assert
      verify(databaseMock.rawQuery(query, ['EXPENSE']));
      expect(result, categories);
    });

    test('should throw DataException when fetching data fails', () async {
      //act
      final call = dataSourceImpl.getCategories;
      //assert
      expect(() => call(type), throwsA(TypeMatcher<DataException>()));
    });
  });

  group('deleteTransaction', () {
    int transactionID = 1;

    test('should delete transaction from database and return true after deletion.', () async {
      // arrange
      when(databaseMock.delete(TransactionTable.TABLE_NAME, where: '${TransactionTable.id}=?', whereArgs: [transactionID]))
          .thenAnswer((_) async => 1);
      //act
      final result = await dataSourceImpl.deleteTransaction(transactionID);
      //assert
      verify(databaseMock.delete(TransactionTable.TABLE_NAME, where: '${TransactionTable.id}=?', whereArgs: [transactionID]));
      expect(result, true);
    });

    test('should return false when no transactions deleted.', () async {
      // arrange
      when(databaseMock.delete(TransactionTable.TABLE_NAME, where: '${TransactionTable.id}=?', whereArgs: [transactionID]))
          .thenAnswer((_) async => 0);
      //act
      final result = await dataSourceImpl.deleteTransaction(transactionID);
      //assert
      verify(databaseMock.delete(TransactionTable.TABLE_NAME, where: '${TransactionTable.id}=?', whereArgs: [transactionID]));
      expect(result, false);
    });

    test('should throw DataException when deletion is not successful.', () async {
      // arrange
      when(databaseMock.delete(TransactionTable.TABLE_NAME, where: '${TransactionTable.id}=?', whereArgs: [transactionID]))
          .thenThrow(Exception());
      //act
      final call = dataSourceImpl.deleteTransaction;
      //assert
      expect(() => call(transactionID), throwsA(TypeMatcher<DataException>()));
    });
  });

  group('updateTransaction', () {
    final DateTime date = DateTime(2021, 05, 14, 14, 13, 29, 104);
    final transaction = TransactionModel(
        transactionID: '1',
        title: 'title',
        amount: 10.10,
        transactionType: TransactionType.INCOME,
        categoryID: 1,
        accountID: 1,
        date: date,
        description: 'desc');
    final updatedTransaction = TransactionModel(
        transactionID: '1',
        title: 'updated',
        amount: 12.10,
        transactionType: TransactionType.INCOME,
        categoryID: 1,
        accountID: 1,
        date: date,
        description: 'desc');
    int transactionID = 1;

    final query = 'SELECT t.*, c.${CategoryTable.icon}, c.${CategoryTable.color} '
        'FROM ${TransactionTable.TABLE_NAME} t '
        'JOIN ${CategoryTable.TABLE_NAME} c ON c.${CategoryTable.id}=t.${TransactionTable.category_id} '
        'WHERE ${TransactionTable.id}=?';
    Map<String, Object?> transactionQuery = {
      "transaction_id": "1",
      "date": "2021-05-14T14:13:29.104",
      "title": "updated",
      "description": "desc",
      "amount": 12.10,
      "transaction_type": "INCOME",
      "category_id": 1,
      "acc_id": 1,
      "icon": 'icon',
      'color': 'color'
    };
    List<Map<String, Object?>> queryResult = [transactionQuery];

    test('should update transaction from database and return updated transaction with true after updating.', () async {
      // arrange
      final Map<String, Object> methodReturn = {
        'isUpdated': true,
        'transaction': updatedTransaction,
      };
      when(databaseMock.update(TransactionTable.TABLE_NAME, TransactionModel.toQuery(transaction),
          where: '${TransactionTable.id}=?', whereArgs: [transactionID])).thenAnswer((_) async => 1);
      when(databaseMock.rawQuery(query, [transactionID])).thenAnswer((_) async => queryResult);
      //act
      final result = await dataSourceImpl.updateTransaction(transaction);
      //assert
      verify(databaseMock.update(TransactionTable.TABLE_NAME, TransactionModel.toQuery(transaction),
          where: '${TransactionTable.id}=?', whereArgs: [transactionID]));
      verify(databaseMock.rawQuery(query, [transactionID]));
      expect(result, methodReturn);
    });

    test('should return false when no transactions updated.', () async {
      // arrange
      final Map<String, Object> methodReturn = {
        'isUpdated': false,
        'transaction': transaction,
      };
      when(databaseMock.update(TransactionTable.TABLE_NAME, TransactionModel.toQuery(transaction),
          where: '${TransactionTable.id}=?', whereArgs: [transactionID])).thenAnswer((_) async => 0);
      when(databaseMock.rawQuery(query, [transactionID])).thenAnswer((_) async => queryResult);
      //act
      final result = await dataSourceImpl.updateTransaction(transaction);
      //assert
      verify(databaseMock.update(TransactionTable.TABLE_NAME, TransactionModel.toQuery(transaction),
          where: '${TransactionTable.id}=?', whereArgs: [transactionID]));
      verifyNever(databaseMock.rawQuery(query, [transactionID]));
      expect(result, methodReturn);
    });

    test('should throw DataException when deletion is not successful.', () async {
      // arrange
      when(databaseMock.update(TransactionTable.TABLE_NAME, TransactionModel.toQuery(transaction),
          where: '${TransactionTable.id}=?', whereArgs: [transactionID])).thenThrow(Exception());
      //act
      final call = dataSourceImpl.updateTransaction;
      //assert
      expect(() => call(transaction), throwsA(TypeMatcher<DataException>()));
    });
  });

  group('getAccounts', () {
    String query = 'SELECT * FROM ${AccountsTable.TABLE_NAME};';

    List<Map<String, Object?>> queryResult = [accountQuery];
    DateTime createdAt = DateTime(2021, 05, 12);
    AccountModel account = AccountModel(
      accountID: 1,
      accountNumber: 12345,
      logo: 'logo',
      bankName: 'bank',
      balance: 10000,
      createdAt: createdAt,
    );

    final accounts = [account];

    test('should fetch all accounts from database', () async {
      // arrange
      when(databaseMock.rawQuery(query)).thenAnswer((_) async => queryResult);
      //act
      final result = await dataSourceImpl.getAccounts();
      //assert
      verify(databaseMock.rawQuery(query));
      expect(result, accounts);
      verifyNoMoreInteractions(databaseMock);
    });

    test('should throw DataException when fetching data fails', () async {
      //act
      final call = dataSourceImpl.getAccounts;
      //assert
      expect(() => call(), throwsA(TypeMatcher<DataException>()));
    });
  });
}
