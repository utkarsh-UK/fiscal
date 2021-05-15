import 'package:equatable/equatable.dart';

class TransactionParam extends Equatable {
  final int transactionBatchSize;
  final String lastFetchedTransactionID;

  TransactionParam({
    this.transactionBatchSize = 10,
    this.lastFetchedTransactionID = '',
  });

  @override
  List<Object?> get props => [transactionBatchSize, lastFetchedTransactionID];
}
