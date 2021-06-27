import 'package:dartz/dartz.dart';
import 'package:f_logs/f_logs.dart';
import 'package:fiscal/core/error/failure.dart';
import 'package:fiscal/core/usecase/usecase.dart';
import 'package:fiscal/domain/enitities/entities.dart';
import 'package:fiscal/domain/repositories/repositories.dart';

class GetAllTransactions extends Usecase<Map<String, List<Transaction>>, Params> {
  static const String CLASS_NAME = 'GetAllTransactions:USECASE';

  final TransactionRepository _repository;

  GetAllTransactions(this._repository);

  @override
  Future<Either<Failure, Map<String, List<Transaction>>>> call(Params params) async {
    FLog.info(text: 'Usecase called', className: CLASS_NAME, methodName: 'call()');

    return await _repository.getAllTransactions(
      params.transactionParam!.lastFetchedTransactionID,
      params.transactionParam!.time,
      params.transactionParam!.transactionBatchSize,
    );
  }
}
