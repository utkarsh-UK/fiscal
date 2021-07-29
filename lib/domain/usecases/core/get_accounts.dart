import 'package:dartz/dartz.dart';
import 'package:f_logs/f_logs.dart';
import 'package:fiscal/core/error/failure.dart';
import 'package:fiscal/core/usecase/usecase.dart';
import 'package:fiscal/domain/enitities/core/account.dart';
import 'package:fiscal/domain/repositories/transaction_repository.dart';

class GetAccounts extends Usecase<List<Account>, NoParams> {
  static const String CLASS_NAME = 'GetAccounts:USECASE';

  final TransactionRepository _repository;

  GetAccounts(this._repository);

  @override
  Future<Either<Failure, List<Account>>> call(NoParams params) async {
    FLog.info(text: 'Usecase called', className: CLASS_NAME, methodName: 'call()');

    return await _repository.getAccounts();
  }
}
