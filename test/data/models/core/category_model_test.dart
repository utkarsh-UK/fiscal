import 'package:fiscal/data/models/models.dart';
import 'package:fiscal/domain/enitities/entities.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/transactions/transaction.dart';

void main() {
  late CategoryModel model;
  late CategoryModel modelWithTransactionJSON;
  late DateTime createdAt;

  setUp(() {
    createdAt = DateTime(2021, 05, 14, 14, 13, 29, 104);
    model = CategoryModel(
      categoryID: 1,
      name: 'category',
      icon: 'category',
      color: 'color',
      createdAt: createdAt,
    );

    modelWithTransactionJSON = CategoryModel(
      categoryID: 1,
      name: '',
      icon: 'category',
      color: 'color',
      createdAt: DateTime.now(),
    );
  });

  test('should be a subclass of Category entity', () async {
    //assert
    expect(model, isA<Category>());
  });

  test('should return valid model when the data is valid', () async {
    // arrange
    Map<String, Object?> modelQuery = categoryQuery;
    //act
    final result = CategoryModel.fromQueryResult(modelQuery);
    //assert
    expect(result, model);
  });

  test('should return valid model when the JSON is valid', () async {
    // arrange
    Map<String, Object?> modelQuery = categoryQuery;
    //act
    final result = CategoryModel.fromQueryResult(modelQuery);
    //assert
    expect(result, model);
  });

  test('should return valid query JSON data when the model is valid', () async {
    //act
    final result = CategoryModel.toQuery(model);
    //assert
    final expectedMap = categoryQuery;
    expectedMap.remove('category_id');
    expect(result, expectedMap);
  });

  test('should return valid JSON when the model is valid', () async {
    //act
    final result = CategoryModel.toJSON(model);
    //assert
    final expectedMap = <String, dynamic>{
      "category_id": 1,
      "created_at": "2021-05-14T14:13:29.104",
      "name": "category",
      "icon": "category",
      "color": 'color',
      "transaction_type": "EXPENSE",
    };
    expect(result, expectedMap);
  });

  test('should return valid model when the Transaction JSON is valid', () async {
    // arrange
    Map<String, Object?> modelQuery = {
      "category_id": 1,
      "icon": "category",
      "color": 'color',
    };
    //act
    final result = CategoryModel.fromTransactionQueryResult(modelQuery);
    //assert
    expect(result, modelWithTransactionJSON);
  });
}
