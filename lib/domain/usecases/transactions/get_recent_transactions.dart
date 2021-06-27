import 'package:dartz/dartz.dart';
import 'package:f_logs/f_logs.dart';
import 'package:fiscal/core/error/failure.dart';
import 'package:fiscal/core/usecase/usecase.dart';
import 'package:fiscal/domain/enitities/entities.dart';
import 'package:fiscal/domain/repositories/transaction_repository.dart';

class GetRecentTransactions extends Usecase<List<Transaction>, NoParams>{
  static const String CLASS_NAME = 'GetRecentTransactions:USECASE';

  final TransactionRepository _repository;

  GetRecentTransactions(TransactionRepository repository) : _repository = repository;

  Future<Either<Failure, List<Transaction>>> call(NoParams noParams) async {
    FLog.info(text: 'Usecase called', className: CLASS_NAME, methodName: 'call()');

    return await _repository.getRecentTransactions();
  }
}
