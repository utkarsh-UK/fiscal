import 'package:equatable/equatable.dart';
import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/domain/enitities/entities.dart';

class TransactionParam extends Equatable {
  final int transactionBatchSize;
  final String lastFetchedTransactionID;
  final String time;
  final Transaction? transaction;
  final TransactionType transactionType;
  final int transactionID;

  TransactionParam({
    this.transactionBatchSize = 10,
    this.lastFetchedTransactionID = '',
    this.time = '',
    this.transaction,
    this.transactionType = TransactionType.EXPENSE,
    this.transactionID = 1,
  });

  @override
  List<Object?> get props => [transactionBatchSize, lastFetchedTransactionID, time];
}
