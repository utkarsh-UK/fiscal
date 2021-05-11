import 'package:equatable/equatable.dart';
import 'package:fiscal/core/utils/static/enums.dart';

class Transaction extends Equatable {
  final String transactionID;
  final String title;
  final String? description;
  final double amount;
  final TransactionType transactionType;
  final String categoryID;
  final int accountID;
  final DateTime date;

  Transaction({
    required this.transactionID,
    required this.title,
    this.description,
    required this.amount,
    required this.transactionType,
    required this.categoryID,
    required this.accountID,
    required this.date,
  });

  @override
  List<Object> get props => [];
}
