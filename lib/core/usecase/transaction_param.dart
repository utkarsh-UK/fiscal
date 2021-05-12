import 'package:equatable/equatable.dart';

class TransactionParam extends Equatable {
  final int transactionBatchSize;

  TransactionParam({
    this.transactionBatchSize = 10,
  });

  @override
  List<Object?> get props => [transactionBatchSize];
}
