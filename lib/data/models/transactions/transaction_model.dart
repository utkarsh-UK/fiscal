import 'package:fiscal/core/core.dart';
import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/domain/enitities/transactions/transaction.dart';

class TransactionModel extends Transaction {
  final String transactionID;
  final String title;
  final String? description;
  final double amount;
  final TransactionType transactionType;
  final String categoryID;
  final int accountID;
  final DateTime date;

  TransactionModel({
    required this.transactionID,
    required this.title,
    this.description,
    required this.amount,
    required this.transactionType,
    required this.categoryID,
    required this.accountID,
    required this.date,
  }) : super(
            transactionID: transactionID,
            title: title,
            description: description,
            amount: amount,
            transactionType: transactionType,
            categoryID: categoryID,
            accountID: accountID,
            date: date);

  factory TransactionModel.fromQueryResult(Map<String, Object?> data) {
    return TransactionModel(
      transactionID: '${data[TransactionTable.id]}',
      title: '${data[TransactionTable.title]}',
      amount: double.parse('${data[TransactionTable.amount]}'),
      description: '${data[TransactionTable.description]}',
      transactionType: Converters.convertTransactionTypeString('${data[TransactionTable.transaction_type]}'),
      categoryID: '${data[TransactionTable.category_id]}',
      accountID: int.parse('${data[TransactionTable.acc_id]}'),
      date: DateTime.parse('${data[TransactionTable.date]}'),
    );
  }

  static Map<String, Object?> toQuery(TransactionModel model) => {
    TransactionTable.id: model.transactionID,
    TransactionTable.title: model.title,
    TransactionTable.description: model.description,
    TransactionTable.amount: model.amount,
    TransactionTable.transaction_type: Converters.convertTransactionTypeEnum(model.transactionType),
    TransactionTable.category_id: model.categoryID,
    TransactionTable.acc_id: model.accountID,
    TransactionTable.date: model.date.toIso8601String(),
  };
}
