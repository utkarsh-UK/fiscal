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
      accountID: int.parse('${data[TransactionTable.acc_id] ?? 0}'),
      date: DateTime.parse('${data[TransactionTable.date] ?? DateTime.now()}'),
    );
  }

  factory TransactionModel.fromJSON(Map<String, dynamic> data) {
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

  factory TransactionModel.fromTransaction(Transaction transaction, {String id = ''}) {
    return TransactionModel(
      transactionID: id.isNotEmpty ? id : transaction.transactionID,
      title: transaction.title,
      amount: transaction.amount,
      description: transaction.description,
      transactionType: transaction.transactionType,
      categoryID: transaction.categoryID,
      accountID: transaction.accountID,
      date: transaction.date,
    );
  }

  static Map<String, Object?> toQuery(TransactionModel model) => {
        TransactionTable.title: model.title,
        TransactionTable.description: model.description,
        TransactionTable.amount: model.amount,
        TransactionTable.transaction_type: Converters.convertTransactionTypeEnum(model.transactionType),
        // TransactionTable.category_id: model.categoryID,
        // TransactionTable.acc_id: model.accountID,
        TransactionTable.date: model.date.toIso8601String(),
      };

  static Map<String, dynamic> toJSON(TransactionModel model) => {
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
