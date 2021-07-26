import 'package:dartz/dartz.dart';
import 'package:fiscal/core/usecase/transaction_param.dart';
import 'package:fiscal/core/usecase/usecase.dart';
import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/domain/enitities/entities.dart';
import 'package:fiscal/domain/usecases/usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'get_recent_transactions_test.mocks.dart';

void main() {
  late UpdateTransaction usecase;
  late MockTransactionRepository mockTransactionRepository;

  setUp(() {
    mockTransactionRepository = MockTransactionRepository();
    usecase = UpdateTransaction(mockTransactionRepository);
  });

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

  test('should update transaction from repository', () async {
    // arrange
    when(mockTransactionRepository.updateTransaction(transaction)).thenAnswer((_) async => Right(true));
    //act
    final result = await usecase(Params(transactionParam: TransactionParam(transaction: transaction)));
    //assert
    verify(mockTransactionRepository.updateTransaction(transaction));
    expect(result, Right(true));
  });
}
