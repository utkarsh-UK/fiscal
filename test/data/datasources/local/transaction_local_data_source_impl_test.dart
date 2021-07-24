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
}
