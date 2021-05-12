import 'package:dartz/dartz.dart';
import 'package:fiscal/core/error/failure.dart';
import 'package:fiscal/core/usecase/usecase.dart';
import 'package:fiscal/domain/enitities/entities.dart';
import 'package:fiscal/domain/repositories/transaction_repository.dart';

class GetRecentTransactions extends Usecase<List<Transaction>, NoParams>{
  final TransactionRepository _repository;

  GetRecentTransactions(TransactionRepository repository) : _repository = repository;

  Future<Either<Failure, List<Transaction>>> call(NoParams noParams) async {
    return await _repository.getRecentTransactions();
  }
}
