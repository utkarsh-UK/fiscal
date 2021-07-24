import 'package:dartz/dartz.dart';
import 'package:fiscal/core/error/exceptions.dart';
import 'package:fiscal/core/error/failure.dart';
import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/core/utils/static/messages.dart';
import 'package:fiscal/data/datasources/local/transaction_local_data_source.dart';
import 'package:fiscal/data/datasources/remote/transaction_remote_data_source.dart';
import 'package:fiscal/data/models/models.dart';
import 'package:fiscal/data/repositories/transaction_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'transaction_repository_impl_test.mocks.dart';

@GenerateMocks([TransactionRemoteDataSource, TransactionLocalDataSource])
void main() {
  late TransactionRepositoryImpl repository;
  late MockTransactionRemoteDataSource mockTransactionRemoteDataSource;
  late MockTransactionLocalDataSource mockTransactionLocalDataSource;

  setUp(() {
    mockTransactionRemoteDataSource = MockTransactionRemoteDataSource();
    mockTransactionLocalDataSource = MockTransactionLocalDataSource();
    repository = TransactionRepositoryImpl(
        remoteDataSource: mockTransactionRemoteDataSource, localDataSource: mockTransactionLocalDataSource);
  });

  DateTime transactionDate = DateTime(2021, 05, 12);
  List<TransactionModel> transactions = [
    TransactionModel(
      transactionID: 'id',
      title: 'title',
      amount: 1.0,
      transactionType: TransactionType.INCOME,
      categoryID: 1,
      accountID: 1,
      date: transactionDate,
    ),
  ];

  group('getRecentTransactions', () {
    test('should return recent transactions for batch size when call to remote data source is successful', () async {
      // arrange
      when(mockTransactionRemoteDataSource.getRecentTransactions()).thenAnswer((_) async => transactions);
      when(mockTransactionLocalDataSource.getRecentTransactions()).thenAnswer((_) async => []);
      //act
      final result = await repository.getRecentTransactions();
      //assert
      verify(mockTransactionRemoteDataSource.getRecentTransactions());
      expect(result, Right(transactions));
    });

    test('should cache recent transactions locally when call to remote data source is successful', () async {
      // arrange
      when(mockTransactionRemoteDataSource.getRecentTransactions()).thenAnswer((_) async => transactions);
      when(mockTransactionLocalDataSource.getRecentTransactions()).thenAnswer((_) async => []);
      //act
      await repository.getRecentTransactions();
      //assert
      verify(mockTransactionRemoteDataSource.getRecentTransactions());
      verify(mockTransactionLocalDataSource.cacheRecentTransactions(transactions));
    });

    test('should return cached recent transactions locally when call to local data source is successful', () async {
      // arrange
      when(mockTransactionRemoteDataSource.getRecentTransactions()).thenAnswer((_) async => transactions);
      when(mockTransactionLocalDataSource.getRecentTransactions()).thenAnswer((_) async => transactions);
      //act
      final result = await repository.getRecentTransactions();
      //assert
      verify(mockTransactionLocalDataSource.getRecentTransactions());
      expect(result, Right(transactions));
      verifyNever(mockTransactionRemoteDataSource.getRecentTransactions());
    });

    test('should return DataFailure when call to remote data source is unsuccessful', () async {
      // arrange
      when(mockTransactionLocalDataSource.getRecentTransactions()).thenAnswer((_) async => []);
      when(mockTransactionRemoteDataSource.getRecentTransactions()).thenThrow(DataException());
      //act
      final result = await repository.getRecentTransactions();
      //assert
      verify(mockTransactionRemoteDataSource.getRecentTransactions());
      expect(result, Left(DataFailure(message: DEFAULT_DATA_EXCEPTION_MESSAGE)));
    });

    test('should return CacheFailure when call to local data source is unsuccessful', () async {
      // arrange
      when(mockTransactionLocalDataSource.getRecentTransactions()).thenThrow(CacheException());
      //act
      final result = await repository.getRecentTransactions();
      //assert
      verify(mockTransactionLocalDataSource.getRecentTransactions());
      expect(result, Left(CacheFailure(message: DEFAULT_CACHE_EXCEPTION_MESSAGE)));
    });
  });

  group('getAllTransactions', () {
    Map<String, List<TransactionModel>> transactionsData = {
      '2021-05-14 01:56:00': transactions,
    };
    String lastFetchedTransactionID = 'id';
    String time = '2021-05-14';

    test('should return all transactions when call to remote data source is successful.', () async {
      // arrange
      when(mockTransactionRemoteDataSource.getAllTransactions(any, any)).thenAnswer((realInvocation) async => transactionsData);
      //act
      final result = await repository.getAllTransactions(lastFetchedTransactionID, time);
      //assert
      verify(mockTransactionRemoteDataSource.getAllTransactions(lastFetchedTransactionID, time, 10));
      expect(result, Right(transactionsData));
    });

    test('should return DataFailure when call to remote data source is unsuccessful.', () async {
      // arrange
      when(mockTransactionRemoteDataSource.getAllTransactions(any, any)).thenThrow(DataException());
      //act
      final result = await repository.getAllTransactions(lastFetchedTransactionID, time);
      //assert
      verify(mockTransactionRemoteDataSource.getAllTransactions(lastFetchedTransactionID, time, 10));
      expect(result, Left(DataFailure(message: DEFAULT_DATA_EXCEPTION_MESSAGE)));
    });
  });

  group('addNewTransaction', () {
    DateTime transactionDate = DateTime(2021, 05, 12);
    TransactionModel transaction = TransactionModel(
      transactionID: '1',
      title: 'title',
      amount: 1.0,
      transactionType: TransactionType.INCOME,
      categoryID: 1,
      accountID: 1,
      date: transactionDate,
    );
    String transactionID = '1';

    test('should return newly added transaction id when call to remote data source is successful.', () async {
      // arrange
      when(mockTransactionRemoteDataSource.addNewTransaction(transaction)).thenAnswer((_) async => transactionID);
      //act
      final result = await repository.addNewTransaction(transaction);
      //assert
      verify(mockTransactionRemoteDataSource.addNewTransaction(transaction));
      verify(mockTransactionLocalDataSource.cacheNewTransaction(transaction));
      expect(result, Right(transactionID));
    });

    test('should return DataFailure when call to remote data source is unsuccessful.', () async {
      // arrange
      when(mockTransactionRemoteDataSource.addNewTransaction(any)).thenThrow(DataException());
      //act
      final result = await repository.addNewTransaction(transaction);
      //assert
      verify(mockTransactionRemoteDataSource.addNewTransaction(transaction));
      expect(result, Left(DataFailure(message: DEFAULT_DATA_EXCEPTION_MESSAGE)));
    });
  });

  group('getDailySummary', () {
    Map<String, Object?> summary = {'total': 100.00, 'income': 50.04, 'expense': 56.23};

    test('should return summary data when call to remote data source is successful.', () async {
      // arrange
      when(mockTransactionRemoteDataSource.getDailySummary()).thenAnswer((_) async => summary);
      //act
      final result = await repository.getDailySummary();
      //assert
      verify(mockTransactionRemoteDataSource.getDailySummary());
      expect(result, Right(summary));
    });

    test('should return DataFailure when call to remote data source is unsuccessful.', () async {
      // arrange
      when(mockTransactionRemoteDataSource.getDailySummary()).thenThrow(DataException());
      //act
      final result = await repository.getDailySummary();
      //assert
      verify(mockTransactionRemoteDataSource.getDailySummary());
      expect(result, Left(DataFailure(message: DEFAULT_DATA_EXCEPTION_MESSAGE)));
    });
  });

  group('getCategories', () {
    DateTime createdAt = DateTime(2021, 05, 12);
    CategoryModel category =
        CategoryModel(categoryID: 1, name: 'category', icon: 'category', color: 'color', createdAt: createdAt);

    final categories = [category];
    final type = TransactionType.EXPENSE;
    final convertedType = 'EXPENSE';

    test('should return all categories when call to remote data source is successful.', () async {
      // arrange
      when(mockTransactionRemoteDataSource.getCategories(convertedType)).thenAnswer((_) async => categories);
      //act
      final result = await repository.getCategories(type);
      //assert
      verify(mockTransactionRemoteDataSource.getCategories(convertedType));
      expect(result, Right(categories));
    });

    test('should return DataFailure when call to remote data source is unsuccessful.', () async {
      // arrange
      when(mockTransactionRemoteDataSource.getCategories(convertedType)).thenThrow(DataException());
      //act
      final result = await repository.getCategories(type);
      //assert
      verify(mockTransactionRemoteDataSource.getCategories(convertedType));
      expect(result, Left(DataFailure(message: DEFAULT_DATA_EXCEPTION_MESSAGE)));
    });
  });
}
