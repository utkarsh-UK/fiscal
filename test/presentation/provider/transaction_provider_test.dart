import 'package:dartz/dartz.dart';
import 'package:fiscal/core/error/failure.dart';
import 'package:fiscal/core/usecase/transaction_param.dart';
import 'package:fiscal/core/usecase/usecase.dart';
import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/core/utils/static/messages.dart';
import 'package:fiscal/domain/enitities/entities.dart';
import 'package:fiscal/domain/usecases/usecases.dart';
import 'package:fiscal/presentation/provider/transaction_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'transaction_provider_test.mocks.dart';

@GenerateMocks([GetAllTransactions, GetRecentTransactions, AddNewTransaction, GetDailySummary])
void main() {
  late TransactionProvider provider;
  late MockGetAllTransactions mockGetAllTransactions;
  late MockGetRecentTransactions mockGetRecentTransactions;
  late MockAddNewTransaction mockAddNewTransaction;
  late MockGetDailySummary mockGetDailySummary;

  setUp(() {
    mockGetAllTransactions = MockGetAllTransactions();
    mockGetRecentTransactions = MockGetRecentTransactions();
    mockAddNewTransaction = MockAddNewTransaction();
    mockGetDailySummary = MockGetDailySummary();

    provider = TransactionProvider(
        getAllTransactions: mockGetAllTransactions,
        getRecentTransactions: mockGetRecentTransactions,
        addNewTransaction: mockAddNewTransaction,
        getDailySummary: mockGetDailySummary);
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
    test('should fetch recent transactions and mark status COMPLETED when transactions are fetched.', () async {
      // arrange
      when(mockGetRecentTransactions(any)).thenAnswer((_) async => Right(transactions));
      //act
      await provider.getRecentTransactions();
      //assert
      verify(mockGetRecentTransactions(NoParams()));
      expect(provider.status, TransactionStatus.COMPLETED);
      expect(provider.data.recentTransactions, transactions);
    });

    test('should mark status ERROR and set error message when transactions are failed.', () async {
      // arrange
      when(mockGetRecentTransactions(any)).thenAnswer((_) async => Left(DataFailure()));
      //act
      await provider.getRecentTransactions();
      //assert
      verify(mockGetRecentTransactions(NoParams()));
      expect(provider.status, TransactionStatus.ERROR);
      expect(provider.error, DEFAULT_DATABASE_FAILURE_MESSAGE);
      expect(provider.data.recentTransactions, isEmpty);
    });
  });

  group('getAllTransactions', () {
    Map<String, List<Transaction>> data = {'data': transactions};
    String lastTransactionID = '';
    String date = transactionDate.toIso8601String();

    test('should fetch all transactions and mark status COMPLETED when transactions are fetched.', () async {
      // arrange
      when(mockGetAllTransactions(any)).thenAnswer((_) async => Right(data));
      //act
      await provider.getAllTransactions(lastTransactionID: lastTransactionID, timestamp: date);
      //assert
      verify(mockGetAllTransactions(
          Params(transactionParam: TransactionParam(time: date, lastFetchedTransactionID: lastTransactionID))));
      expect(provider.status, TransactionStatus.COMPLETED);
      expect(provider.data.allTransactions, transactions);
    });

    test('should mark status ERROR and set error message when transactions are failed.', () async {
      // arrange
      when(mockGetAllTransactions(any)).thenAnswer((_) async => Left(DataFailure()));
      //act
      await provider.getAllTransactions(lastTransactionID: lastTransactionID, timestamp: date);
      //assert
      verify(mockGetAllTransactions(
          Params(transactionParam: TransactionParam(time: date, lastFetchedTransactionID: lastTransactionID))));
      expect(provider.status, TransactionStatus.ERROR);
      expect(provider.error, DEFAULT_DATABASE_FAILURE_MESSAGE);
      expect(provider.data.allTransactions, isEmpty);
    });
  });

  group('addNewTransaction', () {
    String id = '1';
    final transaction = Transaction(
      transactionID: 'id',
      title: 'title',
      amount: 1.0,
      transactionType: TransactionType.INCOME,
      categoryID: 'category',
      accountID: 1,
      date: transactionDate,
      description: 'description',
    );

    test('should add new transaction and mark status COMPLETED when transaction is added', () async {
      // arrange
      when(mockAddNewTransaction(any)).thenAnswer((_) async => Right(id));
      //act
      await provider.addNewTransaction(
        date: transactionDate,
        accountID: 1,
        categoryID: 'category',
        amount: 1.0,
        title: 'title',
        type: TransactionType.INCOME,
        description: 'description',
      );
      //assert
      verify(mockAddNewTransaction(Params(transactionParam: TransactionParam(transaction: transaction))));
      expect(provider.status, TransactionStatus.ADDED);
    });

    test('should mark status ERROR and set error message when transactions are failed.', () async {
      // arrange
      when(mockAddNewTransaction(any)).thenAnswer((_) async => Left(DataFailure()));
      //act
      await provider.addNewTransaction(
        date: transactionDate,
        accountID: 1,
        categoryID: 'category',
        amount: 1.0,
        title: 'title',
        type: TransactionType.INCOME,
        description: 'description',
      );
      //assert
      verify(mockAddNewTransaction(Params(transactionParam: TransactionParam(transaction: transaction))));
      expect(provider.status, TransactionStatus.ERROR);
      expect(provider.error, DEFAULT_DATABASE_FAILURE_MESSAGE);
    });
  });
  group('getDailySummary', () {
    Map<String, Object?> summary = {'total': 100.00, 'income': 50.04, 'expense': 56.23};

    test('should get summary and set status to COMPLETED when data is fetched', () async {
      // arrange
      when(mockGetDailySummary(any)).thenAnswer((_) async => Right(summary));
      //act
      await provider.getDailySummary();
      //assert
      verify(mockGetDailySummary(NoParams()));
      expect(provider.status, TransactionStatus.SUMMARY_LOADED);
    });

    test('should mark status ERROR and set error message when summary is failed.', () async {
      // arrange
      when(mockGetDailySummary(any)).thenAnswer((_) async => Left(DataFailure()));
      //act
      await provider.getDailySummary();
      //assert
      verify(mockGetDailySummary(NoParams()));
      expect(provider.status, TransactionStatus.ERROR);
      expect(provider.error, DEFAULT_DATABASE_FAILURE_MESSAGE);
    });
  });
}
