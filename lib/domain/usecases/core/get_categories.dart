import 'package:dartz/dartz.dart';
import 'package:f_logs/f_logs.dart';
import 'package:fiscal/core/error/failure.dart';
import 'package:fiscal/core/usecase/usecase.dart';
import 'package:fiscal/domain/enitities/core/category.dart';
import 'package:fiscal/domain/repositories/transaction_repository.dart';

class GetCategories extends Usecase<List<Category>, Params> {
  static const String CLASS_NAME = 'GetCategories:USECASE';

  final TransactionRepository _repository;

  GetCategories(this._repository);

  @override
  Future<Either<Failure, List<Category>>> call(Params params) async {
    FLog.info(text: 'Usecase called', className: CLASS_NAME, methodName: 'call()');

    return await _repository.getCategories(params.transactionParam!.transactionType);
  }
}
