import 'package:dartz/dartz.dart';
import 'package:fiscal/core/error/failure.dart';
import 'package:fiscal/core/usecase/usecase.dart';
import 'package:fiscal/domain/enitities/entities.dart';
import 'package:fiscal/domain/repositories/repositories.dart';

class GetAllTransactions extends Usecase<Map<String, List<Transaction>>, Params> {
  final TransactionRepository _repository;

  GetAllTransactions(this._repository);

  @override
  Future<Either<Failure, Map<String, List<Transaction>>>> call(Params params) async {
    return await _repository.getAllTransactions(
      params.transactionParam!.lastFetchedTransactionID,
      params.transactionParam!.transactionBatchSize,
    );
  }
}
