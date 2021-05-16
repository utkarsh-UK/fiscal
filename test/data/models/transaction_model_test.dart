import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/data/models/models.dart';
import 'package:fiscal/domain/enitities/entities.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/transactions/transaction.dart';

void main() {
  late TransactionModel model;

  setUp(() {
    final DateTime date = DateTime(2021, 05, 14, 14, 13, 29, 104);
    model = TransactionModel(
      transactionID: 'id',
      title: 'title',
      amount: 10.10,
      transactionType: TransactionType.INCOME,
      categoryID: 'category',
      accountID: 1,
      date: date,
      description: 'desc'
    );
  });

  test('should be a subclass of Transaction entity', () async {
    //assert
    expect(model, isA<Transaction>());
  });

  test('should return valid model when the data is valid', () async {
    // arrange
    Map<String, Object?> modelQuery = transactionQuery;
    //act
    final result = TransactionModel.fromQueryResult(modelQuery);
    //assert
    expect(result, model);
  });

  test('should return valid JSON when the model is valid', () async {
    //act
    final result = TransactionModel.toQuery(model);
    //assert
    final expectedMap = transactionQuery;
    expect(result, expectedMap);
  });
}
