import 'package:dartz/dartz.dart';
import 'package:fiscal/core/usecase/usecase.dart';
import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/domain/enitities/entities.dart';
import 'package:fiscal/domain/repositories/repositories.dart';
import 'package:fiscal/domain/usecases/usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_recent_transactions_test.mocks.dart';

@GenerateMocks([TransactionRepository])
void main() {
  late GetRecentTransactions usecase;
  late MockTransactionRepository mockTransactionRepository;

  setUp(() {
    mockTransactionRepository = MockTransactionRepository();
    usecase = GetRecentTransactions(mockTransactionRepository);
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

  test('should get recent transactions from the repository', () async {
    // arrange
    when(mockTransactionRepository.getRecentTransactions()).thenAnswer((realInvocation) async => Right(transactions));
    //act
    final result = await usecase(NoParams());
    //assert
    expect(result, Right(transactions));
    verify(mockTransactionRepository.getRecentTransactions());
    verifyNoMoreInteractions(mockTransactionRepository);
  });
}
