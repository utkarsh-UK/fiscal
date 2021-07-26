import 'package:dartz/dartz.dart';
import 'package:fiscal/core/error/failure.dart';
import 'package:fiscal/core/usecase/transaction_param.dart';
import 'package:fiscal/core/usecase/usecase.dart';
import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/core/utils/static/messages.dart';
import 'package:fiscal/domain/enitities/entities.dart';
import 'package:fiscal/domain/usecases/core/get_categories.dart';
import 'package:fiscal/domain/usecases/usecases.dart';
import 'package:fiscal/presentation/provider/transaction_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'transaction_provider_test.mocks.dart';

@GenerateMocks([
  GetAllTransactions,
  GetRecentTransactions,
  AddNewTransaction,
  GetDailySummary,
  GetCategories,
  DeleteTransaction,
  UpdateTransaction,
])
void main() {
  late TransactionProvider provider;
  late MockGetAllTransactions mockGetAllTransactions;
  late MockGetRecentTransactions mockGetRecentTransactions;
  late MockAddNewTransaction mockAddNewTransaction;
  late MockGetDailySummary mockGetDailySummary;
  late MockGetCategories mockGetCategories;
  late MockDeleteTransaction mockDeleteTransaction;
  late MockUpdateTransaction mockUpdateTransaction;

  setUp(() {
    mockGetAllTransactions = MockGetAllTransactions();
    mockGetRecentTransactions = MockGetRecentTransactions();
    mockAddNewTransaction = MockAddNewTransaction();
    mockGetDailySummary = MockGetDailySummary();
    mockGetCategories = MockGetCategories();
    mockDeleteTransaction = MockDeleteTransaction();
    mockUpdateTransaction = MockUpdateTransaction();

    provider = TransactionProvider(
      getAllTransactions: mockGetAllTransactions,
      getRecentTransactions: mockGetRecentTransactions,
      addNewTransaction: mockAddNewTransaction,
      getDailySummary: mockGetDailySummary,
      getCategories: mockGetCategories,
      deleteTransaction: mockDeleteTransaction,
      updateTransaction: mockUpdateTransaction,
    );
  });

  DateTime transactionDate = DateTime(2021, 05, 12);
  List<Transaction> transactions = [
    Transaction(
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
    test('should fetch recent transactions and mark status COMPLETED when transactions are fetched.', () async {
      // arrange
      when(mockGetRecentTransactions(any)).thenAnswer((_) async => Right(transactions));
      //act
      await provider.getRecentTransactions();
      //assert
      verify(mockGetRecentTransactions(NoParams()));
      expect(provider.status, TransactionStatus.COMPLETED);
      expect(provider.providerData.recentTransactions, transactions);
    });

    test('should mark status ERROR and set error message when transactions are failed.', () async {
      // arrange
      when(mockGetRecentTransactions(any)).thenAnswer((_) async => Left(DataFailure()));
      //act
      await provider.getRecentTransactions();
      //assert
      verify(mockGetRecentTransactions(NoParams()));
      expect(provider.status, TransactionStatus.RECENT_TRANS_ERR);
      expect(provider.error, DEFAULT_DATABASE_FAILURE_MESSAGE);
      expect(provider.providerData.recentTransactions, isEmpty);
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
      expect(provider.providerData.allTransactions, transactions);
    });

    test('should mark status ERROR and set error message when transactions are failed.', () async {
      // arrange
      when(mockGetAllTransactions(any)).thenAnswer((_) async => Left(DataFailure()));
      //act
      await provider.getAllTransactions(lastTransactionID: lastTransactionID, timestamp: date);
      //assert
      verify(mockGetAllTransactions(
          Params(transactionParam: TransactionParam(time: date, lastFetchedTransactionID: lastTransactionID))));
      expect(provider.status, TransactionStatus.ALL_TRANS_ERR);
      expect(provider.error, DEFAULT_DATABASE_FAILURE_MESSAGE);
      expect(provider.providerData.allTransactions, isEmpty);
    });
  });

  group('addNewTransaction', () {
    String id = '1';
    final transaction = Transaction(
      transactionID: 'id',
      title: 'title',
      amount: 1.0,
      transactionType: TransactionType.INCOME,
      categoryID: 1,
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
        categoryID: 1,
        amount: 1.0,
        title: 'title',
        type: TransactionType.INCOME,
        description: 'description',
        icon: 'icon',
        color: 'color',
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
        categoryID: 1,
        amount: 1.0,
        title: 'title',
        type: TransactionType.INCOME,
        description: 'description',
        icon: 'icon',
        color: 'color',
      );
      //assert
      verify(mockAddNewTransaction(Params(transactionParam: TransactionParam(transaction: transaction))));
      expect(provider.status, TransactionStatus.ADD_TRANS_ERR);
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
      expect(provider.status, TransactionStatus.SUMMARY_ERR);
      expect(provider.error, DEFAULT_DATABASE_FAILURE_MESSAGE);
    });
  });

  group('getCategories', () {
    DateTime createdAt = DateTime(2021, 05, 12);
    Category category = Category(categoryID: 1, name: 'category', icon: 'category', color: 'color', createdAt: createdAt);

    final categories = [category];
    final type = TransactionType.EXPENSE;

    test('should fetch categories when usecase call is successful.', () async {
      // arrange
      when(mockGetCategories(any)).thenAnswer((_) async => Right(categories));
      //act
      final result = await provider.getCategories(type);
      //assert
      verify(mockGetCategories(Params(transactionParam: TransactionParam(transactionType: type))));
      expect(result, categories);
    });

    test('should return empty list when fetching categories is failed.', () async {
      // arrange
      when(mockGetCategories(any)).thenAnswer((_) async => Left(DataFailure()));
      //act
      final result = await provider.getCategories(type);
      //assert
      verify(mockGetCategories(Params(transactionParam: TransactionParam(transactionType: type))));
      expect(result, isEmpty);
    });
  });

  group('DeleteTransaction', () {
    int id = 1;

    test('should delete transaction and mark status as DELETED', () async {
      // arrange
      when(mockDeleteTransaction(any)).thenAnswer((_) async => Right(false));
      //act
      await provider.deleteTransaction(id);
      //assert
      verify(mockDeleteTransaction(Params(transactionParam: TransactionParam(transactionID: id))));
      expect(provider.status, TransactionStatus.DELETED);
    });

    test('should mark status TRANS_DELETE_ERR and set error message when transactions are failed.', () async {
      // arrange
      when(mockDeleteTransaction(any)).thenAnswer((_) async => Left(DataFailure()));
      //act
      await provider.deleteTransaction(id);
      //assert
      verify(mockDeleteTransaction(Params(transactionParam: TransactionParam(transactionID: id))));
      expect(provider.status, TransactionStatus.TRANS_DELETE_ERR);
      expect(provider.error, DEFAULT_DATABASE_FAILURE_MESSAGE);
    });
  });

  group('UpdateTransaction', () {
    DateTime transactionDate = DateTime(2021, 05, 12);
    Transaction transaction = Transaction(
      transactionID: 'id',
      title: 'title',
      amount: 1.0,
      transactionType: TransactionType.INCOME,
      categoryID: 1,
      accountID: 1,
      date: transactionDate,
    );

    test('should update transaction and mark status as UPDATED', () async {
      // arrange
      when(mockUpdateTransaction(any)).thenAnswer((_) async => Right(false));
      //act
      await provider.updateTransaction(transaction);
      //assert
      verify(mockUpdateTransaction(Params(transactionParam: TransactionParam(transaction: transaction))));
      expect(provider.status, TransactionStatus.UPDATED);
    });

    test('should mark status TRANS_UPDATE_ERR and set error message when transactions are failed.', () async {
      // arrange
      when(mockUpdateTransaction(any)).thenAnswer((_) async => Left(DataFailure()));
      //act
      await provider.updateTransaction(transaction);
      //assert
      verify(mockUpdateTransaction(Params(transactionParam: TransactionParam(transaction: transaction))));
      expect(provider.status, TransactionStatus.TRANS_UPDATE_ERR);
      expect(provider.error, DEFAULT_DATABASE_FAILURE_MESSAGE);
    });
  });
}
