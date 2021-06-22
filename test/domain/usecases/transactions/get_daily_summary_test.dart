import 'package:dartz/dartz.dart';
import 'package:fiscal/core/usecase/usecase.dart';
import 'package:fiscal/domain/usecases/transactions/get_daily_summary.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'get_recent_transactions_test.mocks.dart';

void main() {
  late GetDailySummary usecase;
  late MockTransactionRepository mockTransactionRepository;

  setUp(() {
    mockTransactionRepository = MockTransactionRepository();
    usecase = GetDailySummary(mockTransactionRepository);
  });

  Map<String, Object?> summary = {'total': 100.00, 'income': 50.04, 'expense': 56.23};

  test('should return summary data from repository', () async {
    // arrange
    when(mockTransactionRepository.getDailySummary()).thenAnswer((_) async => Right(summary));
    //act
    final result = await usecase(NoParams());
    //assert
    verify(mockTransactionRepository.getDailySummary());
    expect(result, Right(summary));
    verifyNoMoreInteractions(mockTransactionRepository);
  });
}
