import 'package:dartz/dartz.dart';
import 'package:fiscal/core/usecase/transaction_param.dart';
import 'package:fiscal/core/usecase/usecase.dart';
import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/domain/enitities/entities.dart';
import 'package:fiscal/domain/usecases/usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'mocks/get_recent_transactions_test.mocks.dart';

void main() {
  late GetAllTransactions usecase;
  late MockTransactionRepository mockTransactionRepository;

  setUp(() {
    mockTransactionRepository = MockTransactionRepository();
    usecase = GetAllTransactions(mockTransactionRepository);
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

  int batchSize = 10;

  test('should get all transactions from the repository', () async {
    // arrange
    when(mockTransactionRepository.getAllTransactions(batchSize)).thenAnswer((realInvocation) async => Right(transactions));
    //act
    final result = await usecase(Params(transactionParam: TransactionParam(transactionBatchSize: batchSize)));
    //assert
    expect(result, Right(transactions));
    verify(mockTransactionRepository.getAllTransactions(batchSize));
    verifyNoMoreInteractions(mockTransactionRepository);
  });
}
