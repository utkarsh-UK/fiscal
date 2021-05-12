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
}
