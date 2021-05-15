import 'package:dartz/dartz.dart';
import 'package:fiscal/core/error/exceptions.dart';
import 'package:fiscal/core/error/failure.dart';
import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/core/utils/static/messages.dart';
import 'package:fiscal/data/datasources/local/transaction_local_data_source.dart';
import 'package:fiscal/data/datasources/remote/transaction_remote_data_source.dart';
import 'package:fiscal/data/repositories/transaction_repository_impl.dart';
import 'package:fiscal/domain/enitities/entities.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'mocks/transaction_repository_impl_test.mocks.dart';

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
  List<Transaction> transactions = [
    Transaction(
      transactionID: 'id',
      title: 'title',
      amount: 1.0,
      transactionType: TransactionType.INCOME,
      categoryID: 'category',
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
    Map<String, List<Transaction>> transactionsData = {
      '2021-05-14 01:56:00': transactions,
    };
    String lastFetchedTransactionID = 'id';

    test('should return all transactions when call to remote data source is successful.', () async {
      // arrange
      when(mockTransactionRemoteDataSource.getAllTransactions(any, any)).thenAnswer((realInvocation) async => transactionsData);
      //act
      final result = await repository.getAllTransactions(lastFetchedTransactionID);
      //assert
      verify(mockTransactionRemoteDataSource.getAllTransactions(lastFetchedTransactionID, 10));
      expect(result, Right(transactionsData));
    });

    test('should return DataFailure when call to remote data source is unsuccessful.', () async {
      // arrange
      when(mockTransactionRemoteDataSource.getAllTransactions(any, any)).thenThrow(DataException());
      //act
      final result = await repository.getAllTransactions(lastFetchedTransactionID);
      //assert
      verify(mockTransactionRemoteDataSource.getAllTransactions(lastFetchedTransactionID, 10));
      expect(result, Left(DataFailure(message: DEFAULT_DATA_EXCEPTION_MESSAGE)));
    });
  });
}
