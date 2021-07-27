import 'package:equatable/equatable.dart';
import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/domain/enitities/entities.dart';

class Transaction extends Equatable {
  final String transactionID;
  final String title;
  final String? description;
  final double amount;
  final TransactionType transactionType;
  final int categoryID;
  final int accountID;
  final DateTime date;
  final Category? category;

  Transaction({
    required this.transactionID,
    required this.title,
    this.description,
    required this.amount,
    required this.transactionType,
    required this.categoryID,
    required this.accountID,
    required this.date,
    this.category,
  });

  Transaction.empty()
      : this.transactionID = '',
        this.title = '',
        this.date = DateTime.now(),
        this.accountID = 0,
        this.categoryID = 0,
        this.amount = 0,
        this.category = null,
        this.description = '',
        this.transactionType = TransactionType.EXPENSE;

  @override
  List<Object> get props => [transactionID, title, amount, date, transactionType];
}
