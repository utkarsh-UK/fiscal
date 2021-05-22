import 'package:equatable/equatable.dart';
import 'package:fiscal/domain/enitities/entities.dart';

class TransactionParam extends Equatable {
  final int transactionBatchSize;
  final String lastFetchedTransactionID;
  final String time;
  final Transaction? transaction;

  TransactionParam({
    this.transactionBatchSize = 10,
    this.lastFetchedTransactionID = '',
    this.time = '',
    this.transaction,
  });

  @override
  List<Object?> get props => [transactionBatchSize, lastFetchedTransactionID, time];
}
