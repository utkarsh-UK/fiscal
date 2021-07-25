import 'package:dartz/dartz.dart';
import 'package:fiscal/core/usecase/transaction_param.dart';
import 'package:fiscal/core/usecase/usecase.dart';
import 'package:fiscal/domain/usecases/transactions/delete_transaction.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'get_recent_transactions_test.mocks.dart';

void main() {
  late DeleteTransaction usecase;
  late MockTransactionRepository mockTransactionRepository;

  setUp(() {
    mockTransactionRepository = MockTransactionRepository();
    usecase = DeleteTransaction(mockTransactionRepository);
  });

  test('should delete transaction from repository.', () async {
    // arrange
    int id = 1;
    when(mockTransactionRepository.deleteTransaction(id)).thenAnswer((_) async => Right(true));
    //act
    final result = await usecase(Params(transactionParam: TransactionParam(transactionID: id)));
    //assert
    verify(mockTransactionRepository.deleteTransaction(id));
    expect(result, Right(true));
  });
}
