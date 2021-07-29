import 'package:dartz/dartz.dart';
import 'package:fiscal/core/usecase/usecase.dart';
import 'package:fiscal/domain/enitities/entities.dart';
import 'package:fiscal/domain/usecases/core/get_accounts.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../transactions/get_recent_transactions_test.mocks.dart';

void main() {
  late GetAccounts usecase;
  late MockTransactionRepository mockTransactionRepository;

  setUp(() {
    mockTransactionRepository = MockTransactionRepository();
    usecase = GetAccounts(mockTransactionRepository);
  });

  DateTime createdAt = DateTime(2021, 05, 12);
  Account account = Account(
    accountID: 1,
    accountNumber: 12345,
    bankName: 'bank',
    logo: 'logo',
    balance: 10000,
    createdAt: createdAt,
  );

  final categories = [account];

  test('should fetch all accounts from repository.', () async {
    // arrange
    when(mockTransactionRepository.getAccounts()).thenAnswer((_) async => Right(categories));
    //act
    final result = await usecase(NoParams());
    //assert
    verify(mockTransactionRepository.getAccounts());
    expect(result, Right(categories));
    verifyNoMoreInteractions(mockTransactionRepository);
  });
}
