import 'package:dartz/dartz.dart';
import 'package:fiscal/core/error/failure.dart';
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

@GenerateMocks([GetAllTransactions, GetRecentTransactions, AddNewTransaction])
void main() {
  late TransactionProvider provider;
  late MockGetAllTransactions mockGetAllTransactions;
  late MockGetRecentTransactions mockGetRecentTransactions;
  late MockAddNewTransaction mockAddNewTransaction;

  setUp(() {
    mockGetAllTransactions = MockGetAllTransactions();
    mockGetRecentTransactions = MockGetRecentTransactions();
    mockAddNewTransaction = MockAddNewTransaction();

    provider = TransactionProvider(
      getAllTransactions: mockGetAllTransactions,
      getRecentTransactions: mockGetRecentTransactions,
      addNewTransaction: mockAddNewTransaction,
    );
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
}
