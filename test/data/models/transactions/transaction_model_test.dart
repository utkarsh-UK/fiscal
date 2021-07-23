import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/data/models/models.dart';
import 'package:fiscal/domain/enitities/entities.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/transactions/transaction.dart';

void main() {
  late TransactionModel model;
  late TransactionModel modelWithIntID;
  late DateTime date;

  setUp(() {
    date = DateTime(2021, 05, 14, 14, 13, 29, 104);
    model = TransactionModel(
        transactionID: 'id',
        title: 'title',
        amount: 10.10,
        transactionType: TransactionType.INCOME,
        categoryID: 'category',
        accountID: 1,
        date: date,
        description: 'desc');
    modelWithIntID = TransactionModel(
        transactionID: '1',
        title: 'title',
        amount: 10.10,
        transactionType: TransactionType.INCOME,
        categoryID: 'category',
        accountID: 1,
        date: date,
        description: 'desc');
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

  test('should return valid model when the JSON is valid', () async {
    // arrange
    Map<String, Object?> modelQuery = transactionQuery;
    //act
    final result = TransactionModel.fromQueryResult(modelQuery);
    //assert
    expect(result, model);
  });

  test('should return valid query JSON data when the model is valid', () async {
    //act
    final result = TransactionModel.toQuery(model);
    //assert
    final expectedMap = transactionQuery;
    expectedMap.remove('transaction_id');
    expect(result, expectedMap);
  });

  test('should return valid JSON when the model is valid', () async {
    //act
    final result = TransactionModel.toJSON(model);
    //assert
    final expectedMap = <String, dynamic>{
      "transaction_id": "id",
      "date": "2021-05-14T14:13:29.104",
      "title": "title",
      "description": "desc",
      "amount": 10.10,
      "transaction_type": "INCOME",
      "category_id": "category",
      "acc_id": 1
    };
    expect(result, expectedMap);
  });

  test('should return valid TransactionModel when Transaction entity is valid', () async {
    //arrange
    final transaction = Transaction(
      transactionID: 'id',
      title: 'title',
      amount: 10.10,
      transactionType: TransactionType.INCOME,
      categoryID: 'category',
      accountID: 1,
      date: date,
      description: 'desc',
    );
    //act
    final result = TransactionModel.fromTransaction(transaction);
    //assert
    expect(result, model);
  });

  test('should return valid TransactionModel when Transaction entity is valid and ID is passed separately', () async {
    //arrange
    final transaction = Transaction(
      transactionID: '1',
      title: 'title',
      amount: 10.10,
      transactionType: TransactionType.INCOME,
      categoryID: 'category',
      accountID: 1,
      date: date,
      description: 'desc',
    );
    //act
    final result = TransactionModel.fromTransaction(transaction, id: '1');
    //assert
    expect(result, modelWithIntID);
  });
}
