import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fiscal/core/error/failure.dart';
import 'package:fiscal/core/usecase/transaction_param.dart';

abstract class Usecase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}

class Params extends Equatable {
  final TransactionParam? transactionParam;

  Params({this.transactionParam});

  @override
  List<Object> get props => [];
}
