import 'dart:convert';

import 'package:fiscal/core/core.dart';
import 'package:fiscal/core/error/exceptions.dart';
import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/data/datasources/local/transaction_local_data_source.dart';
import 'package:fiscal/data/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fixtures/transactions/transaction.dart';
import 'transaction_local_data_source_impl_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late TransactionLocalDataSourceImpl localDataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localDataSource = TransactionLocalDataSourceImpl(mockSharedPreferences);
  });

  final DateTime date = DateTime(2021, 05, 14, 14, 13, 29, 104);
  final transaction = TransactionModel(
    transactionID: 'id',
    title: 'title',
    amount: 10.10,
    transactionType: TransactionType.INCOME,
    categoryID: 1,
    accountID: 1,
    date: date,
    description: 'desc',
    category: CategoryModel(categoryID: 1, name: '', icon: 'icon', color: 'color'),
    account: AccountModel(accountID: 1, accountNumber: 12345, bankName: 'bank', balance: 10000, logo: 'logo'),
  );

  final transactionsList = [transaction, transaction];
  final serializedList = transactionsList.map((t) => TransactionModel.toJSON(t)).toList();

  group('cacheNewTransaction', () {
    test('should cache transaction when new transaction is added', () async {
      // arrange
      when(mockSharedPreferences.setString(any, any)).thenAnswer((_) async => true);
      when(mockSharedPreferences.getString(any)).thenReturn(json.encode([transactionQuery]));
      //act
      await localDataSource.cacheNewTransaction(transaction);
      //assert
      verify(mockSharedPreferences.setString(RECENT_TRANS_SHARED_PREF_KEY, json.encode(serializedList)));
    });

    test('should cache transaction when no recent transactions present in cache', () async {
      // arrange
      final singleTransactionList = [serializedList[0]];
      when(mockSharedPreferences.setString(any, any)).thenAnswer((_) async => true);
      when(mockSharedPreferences.getString(RECENT_TRANS_SHARED_PREF_KEY)).thenReturn(null);
      //act
      await localDataSource.cacheNewTransaction(transaction);
      //assert
      verify(mockSharedPreferences.setString(RECENT_TRANS_SHARED_PREF_KEY, json.encode(singleTransactionList)));
    });

    test('should throw CacheException when caching goes wrong', () async {
      // arrange
      when(mockSharedPreferences.setString(any, any)).thenThrow(CacheException());
      //act
      final call = localDataSource.cacheNewTransaction;
      //assert
      expect(() => call(transaction), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('cacheRecentTransactions', () {
    test('should cache given recent transactions', () async {
      // arrange
      when(mockSharedPreferences.setString(any, any)).thenAnswer((_) async => true);
      //act
      await localDataSource.cacheRecentTransactions(transactionsList);
      //assert
      verify(mockSharedPreferences.setString(RECENT_TRANS_SHARED_PREF_KEY, json.encode(serializedList)));
    });

    test('should throw CacheException when caching goes wrong', () async {
      // arrange
      when(mockSharedPreferences.setString(any, any)).thenThrow(CacheException());
      //act
      final call = localDataSource.cacheRecentTransactions;
      //assert
      expect(() => call(transactionsList), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('getRecentTransactions', () {
    test('should return recent transactions from cache', () async {
      // arrange
      when(mockSharedPreferences.setString(any, any)).thenAnswer((_) async => true);
      when(mockSharedPreferences.getString(any)).thenReturn(json.encode([transactionQuery, transactionQuery]));
      //act
      final result = await localDataSource.getRecentTransactions();
      //assert
      verify(mockSharedPreferences.getString(RECENT_TRANS_SHARED_PREF_KEY));
      expect(result, transactionsList);
    });

    test('should return empty transactions when no transactions present in cache.', () async {
      // arrange
      when(mockSharedPreferences.setString(any, any)).thenAnswer((_) async => true);
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      //act
      final result = await localDataSource.getRecentTransactions();
      //assert
      verify(mockSharedPreferences.getString(RECENT_TRANS_SHARED_PREF_KEY));
      expect(result, isEmpty);
    });

    test('should throw CacheException when caching goes wrong', () async {
      // arrange
      when(mockSharedPreferences.setString(any, any)).thenThrow(CacheException());
      //act
      final call = localDataSource.getRecentTransactions;
      //assert
      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('removeTransaction', () {
    int transactionID = 1;

    final DateTime date = DateTime(2021, 05, 14, 14, 13, 29, 104);
    Map<String, Object?> transCached1 = {
      "transaction_id": "1",
      "date": "2021-05-14T14:13:29.104",
      "title": "title",
      "description": "desc",
      "amount": 10.10,
      "transaction_type": "INCOME",
      "category_id": 1,
      "acc_id": 1,
      "icon": 'icon',
      'color': 'color',
      'bank_name': 'bank',
      'account_no': 12345,
      'account_id': 1
    };

    Map<String, Object?> transCached2 = {
      "transaction_id": "2",
      "date": "2021-05-14T14:13:29.104",
      "title": "title",
      "description": "desc",
      "amount": 10.10,
      "transaction_type": "INCOME",
      "category_id": 1,
      "acc_id": 1,
      "icon": 'icon',
      'color': 'color',
      'bank_name': 'bank',
      'account_no': 12345,
      'account_id': 1
    };

    final trans = TransactionModel(
      transactionID: '2',
      title: 'title',
      amount: 10.10,
      transactionType: TransactionType.INCOME,
      categoryID: 1,
      accountID: 1,
      date: date,
      description: 'desc',
      category: CategoryModel(categoryID: 1, name: '', icon: 'icon', color: 'color'),
      account: AccountModel(accountID: 1, accountNumber: 12345, bankName: 'bank', balance: 10000, logo: 'logo'),
    );

    final transList = [trans];
    final serializedTransList = transList.map((t) => TransactionModel.toJSON(t)).toList();

    test('should remove cached transaction if it is cached', () async {
      // arrange
      when(mockSharedPreferences.setString(any, any)).thenAnswer((_) async => true);
      when(mockSharedPreferences.getString(RECENT_TRANS_SHARED_PREF_KEY)).thenReturn(json.encode([transCached1, transCached2]));
      //act
      await localDataSource.removeTransaction(transactionID);
      //assert
      verify(mockSharedPreferences.setString(RECENT_TRANS_SHARED_PREF_KEY, json.encode(serializedTransList)));
    });

    test('should return directly when no transaction present in cache', () async {
      // arrange
      when(mockSharedPreferences.setString(any, any)).thenAnswer((_) async => true);
      when(mockSharedPreferences.getString(any)).thenReturn(json.encode([transCached1, transCached2]));
      //act
      await localDataSource.removeTransaction(2);
      //assert
      verifyNever(mockSharedPreferences.setString(RECENT_TRANS_SHARED_PREF_KEY, json.encode(serializedTransList)));
    });

    test('should throw CacheException when caching goes wrong', () async {
      // arrange
      when(mockSharedPreferences.setString(any, any)).thenThrow(CacheException());
      //act
      final call = localDataSource.removeTransaction;
      //assert
      expect(() => call(transactionID), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('updateTransaction', () {
    final DateTime date = DateTime(2021, 05, 14, 14, 13, 29, 104);
    Map<String, Object?> transCached1 = {
      "transaction_id": "1",
      "date": "2021-05-14T14:13:29.104",
      "title": "title",
      "description": "desc",
      "amount": 10.10,
      "transaction_type": "INCOME",
      "category_id": 1,
      "acc_id": 1,
      "icon": 'icon',
      'color': 'color',
      'bank_name': 'bank',
      'account_no': 12345,
      'account_id': 1
    };

    Map<String, Object?> transCached2 = {
      "transaction_id": "2",
      "date": "2021-05-14T14:13:29.104",
      "title": "title",
      "description": "desc",
      "amount": 10.10,
      "transaction_type": "INCOME",
      "category_id": 1,
      "acc_id": 1,
      "icon": 'icon',
      'color': 'color',
      'bank_name': 'bank',
      'account_no': 12345,
      'account_id': 1
    };

    final trans1 = TransactionModel(
      transactionID: '1',
      title: 'updatedTitle',
      amount: 10.10,
      transactionType: TransactionType.INCOME,
      categoryID: 1,
      accountID: 1,
      date: date,
      description: 'desc',
      category: CategoryModel(categoryID: 1, name: '', icon: 'icon', color: 'color'),
    );

    final trans2 = TransactionModel(
      transactionID: '2',
      title: 'title',
      amount: 10.10,
      transactionType: TransactionType.INCOME,
      categoryID: 1,
      accountID: 1,
      date: date,
      description: 'desc',
      category: CategoryModel(categoryID: 1, name: '', icon: 'icon', color: 'color'),
      account: AccountModel(accountID: 1, accountNumber: 12345, bankName: 'bank', balance: 10000, logo: 'logo'),
    );

    final transList = [trans1, trans2];
    final serializedTransList = transList.map((t) => TransactionModel.toJSON(t)).toList();

    test('should update cached transaction if it is present', () async {
      // arrange
      when(mockSharedPreferences.setString(any, any)).thenAnswer((_) async => true);
      when(mockSharedPreferences.getString(RECENT_TRANS_SHARED_PREF_KEY)).thenReturn(json.encode([transCached1, transCached2]));
      //act
      await localDataSource.updateTransaction(trans1);
      //assert
      verify(mockSharedPreferences.setString(RECENT_TRANS_SHARED_PREF_KEY, json.encode(serializedTransList)));
    });

    test('should return directly when no transaction present in cache', () async {
      // arrange
      when(mockSharedPreferences.setString(any, any)).thenAnswer((_) async => true);
      when(mockSharedPreferences.getString(any)).thenReturn(json.encode([transCached2]));
      //act
      await localDataSource.updateTransaction(trans1);
      //assert
      verifyNever(mockSharedPreferences.setString(RECENT_TRANS_SHARED_PREF_KEY, json.encode(serializedTransList)));
    });

    test('should throw CacheException when caching goes wrong', () async {
      // arrange
      when(mockSharedPreferences.setString(any, any)).thenThrow(CacheException());
      //act
      final call = localDataSource.updateTransaction;
      //assert
      expect(() => call(transaction), throwsA(TypeMatcher<CacheException>()));
    });
  });
}
