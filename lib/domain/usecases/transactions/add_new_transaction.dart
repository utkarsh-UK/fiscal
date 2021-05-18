import 'package:dartz/dartz.dart';
import 'package:fiscal/core/error/failure.dart';
import 'package:fiscal/core/usecase/usecase.dart';
import 'package:fiscal/domain/repositories/repositories.dart';

class AddNewTransaction extends Usecase<String, Params> {
  final TransactionRepository _repository;

  AddNewTransaction(this._repository);

  @override
  Future<Either<Failure, String>> call(Params params) async {
    return await _repository.addNewTransaction(params.transactionParam!.transaction!);
  }
}