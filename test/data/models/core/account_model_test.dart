import 'package:fiscal/data/models/models.dart';
import 'package:fiscal/domain/enitities/entities.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/transactions/transaction.dart';

void main() {
  late AccountModel model;
  late AccountModel modelWithTransactionJSON;
  late DateTime createdAt;

  setUp(() {
    createdAt = DateTime(2021, 05, 14, 14, 13, 29, 104);
    model = AccountModel(
      accountID: 1,
      accountNumber: 12345,
      bankName: 'bank',
      balance: 10000,
      logo: 'logo',
      createdAt: createdAt,
    );

    modelWithTransactionJSON = AccountModel(
      accountID: 1,
      accountNumber: 12345,
      bankName: 'bank',
      balance: -1.0,
      logo: 'logo',
      createdAt: DateTime.now(),
    );
  });

  test('should be a subclass of Account entity', () async {
    //assert
    expect(model, isA<Account>());
  });

  test('should return valid model when the data is valid', () async {
    // arrange
    Map<String, Object?> modelQuery = accountQuery;
    //act
    final result = AccountModel.fromQueryResult(modelQuery);
    //assert
    expect(result, model);
  });

  test('should return valid model when the JSON is valid', () async {
    // arrange
    Map<String, Object?> modelQuery = accountQuery;
    //act
    final result = AccountModel.fromQueryResult(modelQuery);
    //assert
    expect(result, model);
  });

  test('should return valid query JSON data when the model is valid', () async {
    //act
    final result = AccountModel.toQuery(model);
    //assert
    final expectedMap = accountQuery;
    expectedMap.remove('account_id');
    expect(result, expectedMap);
  });

  test('should return valid JSON when the model is valid', () async {
    //act
    final result = AccountModel.toJSON(model);
    //assert
    final expectedMap = <String, dynamic>{
      "account_id": 1,
      "account_no": 12345,
      "timestamp": "2021-05-14T14:13:29.104",
      "bank_name": "bank",
      "logo": "logo",
      "account_type": "SAVINGS",
      "balance": 10000.0,
    };
    expect(result, expectedMap);
  });

  test('should return valid model when the Transaction JSON is valid', () async {
    // arrange
    Map<String, Object?> modelQuery = {
      "account_id": 1,
      "account_no": 12345,
      "logo": "logo",
      "bank_name": "bank",
    };
    //act
    final result = AccountModel.fromTransactionQueryResult(modelQuery);
    //assert
    expect(result, modelWithTransactionJSON);
  });
}
