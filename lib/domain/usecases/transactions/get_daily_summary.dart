import 'package:dartz/dartz.dart';
import 'package:f_logs/f_logs.dart';
import 'package:fiscal/core/error/failure.dart';
import 'package:fiscal/core/usecase/usecase.dart';
import 'package:fiscal/domain/repositories/transaction_repository.dart';

class GetDailySummary extends Usecase<Map<String, Object?>, NoParams> {
  static const String CLASS_NAME = 'GetDailySummary:USECASE';

  final TransactionRepository _repository;

  GetDailySummary(this._repository);

  @override
  Future<Either<Failure, Map<String, Object?>>> call(NoParams params) async {
    FLog.info(text: 'Usecase called', className: CLASS_NAME, methodName: 'call()');

    return await _repository.getDailySummary();
  }
}
