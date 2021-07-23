import 'package:dartz/dartz.dart';
import 'package:fiscal/core/usecase/transaction_param.dart';
import 'package:fiscal/core/usecase/usecase.dart';
import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/domain/enitities/entities.dart';
import 'package:fiscal/domain/usecases/core/get_categories.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../transactions/get_recent_transactions_test.mocks.dart';

void main() {
  late GetCategories usecase;
  late MockTransactionRepository mockTransactionRepository;

  setUp(() {
    mockTransactionRepository = MockTransactionRepository();
    usecase = GetCategories(mockTransactionRepository);
  });

  DateTime createdAt = DateTime(2021, 05, 12);
  Category category = Category(categoryID: 1, name: 'category', icon: 'category', color: 'color', createdAt: createdAt);

  final categories = [category];

  test('should fetch all categories from repository.', () async {
    // arrange
    when(mockTransactionRepository.getCategories(TransactionType.EXPENSE)).thenAnswer((_) async => Right(categories));
    //act
    final result = await usecase(Params(transactionParam: TransactionParam(transactionType: TransactionType.EXPENSE)));
    //assert
    verify(mockTransactionRepository.getCategories(TransactionType.EXPENSE));
    expect(result, Right(categories));
    verifyNoMoreInteractions(mockTransactionRepository);
  });
}
