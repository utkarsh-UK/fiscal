// Mocks generated by Mockito 5.0.7 from annotations
// in fiscal/test/presentation/provider/transaction_provider_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:fiscal/core/error/failure.dart' as _i5;
import 'package:fiscal/core/usecase/usecase.dart' as _i7;
import 'package:fiscal/domain/enitities/core/category.dart' as _i12;
import 'package:fiscal/domain/enitities/transactions/transaction.dart' as _i6;
import 'package:fiscal/domain/usecases/core/get_categories.dart' as _i11;
import 'package:fiscal/domain/usecases/transactions/add_new_transaction.dart'
    as _i9;
import 'package:fiscal/domain/usecases/transactions/get_all_transactions.dart'
    as _i3;
import 'package:fiscal/domain/usecases/transactions/get_daily_summary.dart'
    as _i10;
import 'package:fiscal/domain/usecases/transactions/get_recent_transactions.dart'
    as _i8;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: comment_references
// ignore_for_file: unnecessary_parenthesis

// ignore_for_file: prefer_const_constructors

// ignore_for_file: avoid_redundant_argument_values

class _FakeEither<L, R> extends _i1.Fake implements _i2.Either<L, R> {}

/// A class which mocks [GetAllTransactions].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetAllTransactions extends _i1.Mock
    implements _i3.GetAllTransactions {
  MockGetAllTransactions() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, Map<String, List<_i6.Transaction>>>> call(
          _i7.Params? params) =>
      (super.noSuchMethod(Invocation.method(#call, [params]),
          returnValue:
              Future<_i2.Either<_i5.Failure, Map<String, List<_i6.Transaction>>>>.value(
                  _FakeEither<_i5.Failure,
                      Map<String, List<_i6.Transaction>>>())) as _i4
          .Future<_i2.Either<_i5.Failure, Map<String, List<_i6.Transaction>>>>);
}

/// A class which mocks [GetRecentTransactions].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetRecentTransactions extends _i1.Mock
    implements _i8.GetRecentTransactions {
  MockGetRecentTransactions() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.Transaction>>> call(
          _i7.NoParams? noParams) =>
      (super.noSuchMethod(Invocation.method(#call, [noParams]),
              returnValue:
                  Future<_i2.Either<_i5.Failure, List<_i6.Transaction>>>.value(
                      _FakeEither<_i5.Failure, List<_i6.Transaction>>()))
          as _i4.Future<_i2.Either<_i5.Failure, List<_i6.Transaction>>>);
}

/// A class which mocks [AddNewTransaction].
///
/// See the documentation for Mockito's code generation for more information.
class MockAddNewTransaction extends _i1.Mock implements _i9.AddNewTransaction {
  MockAddNewTransaction() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, String>> call(_i7.Params? params) =>
      (super.noSuchMethod(Invocation.method(#call, [params]),
              returnValue: Future<_i2.Either<_i5.Failure, String>>.value(
                  _FakeEither<_i5.Failure, String>()))
          as _i4.Future<_i2.Either<_i5.Failure, String>>);
}

/// A class which mocks [GetDailySummary].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetDailySummary extends _i1.Mock implements _i10.GetDailySummary {
  MockGetDailySummary() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, Map<String, Object?>>> call(
          _i7.NoParams? params) =>
      (super.noSuchMethod(Invocation.method(#call, [params]),
              returnValue:
                  Future<_i2.Either<_i5.Failure, Map<String, Object?>>>.value(
                      _FakeEither<_i5.Failure, Map<String, Object?>>()))
          as _i4.Future<_i2.Either<_i5.Failure, Map<String, Object?>>>);
}

/// A class which mocks [GetCategories].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetCategories extends _i1.Mock implements _i11.GetCategories {
  MockGetCategories() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i12.Category>>> call(
          _i7.Params? params) =>
      (super.noSuchMethod(Invocation.method(#call, [params]),
              returnValue:
                  Future<_i2.Either<_i5.Failure, List<_i12.Category>>>.value(
                      _FakeEither<_i5.Failure, List<_i12.Category>>()))
          as _i4.Future<_i2.Either<_i5.Failure, List<_i12.Category>>>);
}
