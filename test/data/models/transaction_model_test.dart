import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/data/models/models.dart';
import 'package:fiscal/domain/enitities/entities.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late TransactionModel model;

  setUp(() {
    final DateTime date = DateTime(2021, 05, 15);
    model = TransactionModel(
      transactionID: 'id',
      title: 'title',
      amount: 10,
      transactionType: TransactionType.INCOME,
      categoryID: 'category',
      accountID: 1,
      date: date,
    );
  });

  test('should be a subclass of Transaction entity', () async {
    //assert
    expect(model, isA<Transaction>());
  });
}
