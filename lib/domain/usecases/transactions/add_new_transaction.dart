import 'package:dartz/dartz.dart';
import 'package:f_logs/f_logs.dart';
import 'package:fiscal/core/error/failure.dart';
import 'package:fiscal/core/usecase/usecase.dart';
import 'package:fiscal/domain/repositories/repositories.dart';

class AddNewTransaction extends Usecase<String, Params> {
  static const String CLASS_NAME = 'AddNewTransaction:USECASE';

  final TransactionRepository _repository;

  AddNewTransaction(this._repository);

  @override
  Future<Either<Failure, String>> call(Params params) async {
    FLog.info(text: 'Usecase called', className: CLASS_NAME, methodName: 'call()');

    return await _repository.addNewTransaction(params.transactionParam!.transaction!);
  }
}