import 'package:dartz/dartz.dart';
import 'package:fiscal/core/error/failure.dart';
import 'package:fiscal/core/usecase/usecase.dart';
import 'package:fiscal/domain/repositories/transaction_repository.dart';

class GetDailySummary extends Usecase<Map<String, Object?>, NoParams> {
  final TransactionRepository _repository;

  GetDailySummary(this._repository);

  @override
  Future<Either<Failure, Map<String, Object?>>> call(NoParams params) async {
    return await _repository.getDailySummary();
  }
}
