import 'package:dartz/dartz.dart';
import 'package:f_logs/f_logs.dart';
import 'package:fiscal/core/error/failure.dart';
import 'package:fiscal/core/usecase/usecase.dart';
import 'package:fiscal/domain/repositories/repositories.dart';

class DeleteTransaction extends Usecase<bool, Params> {
  static const String CLASS_NAME = 'DeleteTransaction:USECASE';

  final TransactionRepository _repository;

  DeleteTransaction(this._repository);

  @override
  Future<Either<Failure, bool>> call(Params params) async {
    FLog.info(text: 'Usecase called', className: CLASS_NAME, methodName: 'call()');

    return await _repository.deleteTransaction(params.transactionParam!.transactionID);
  }
}
