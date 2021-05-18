// Mocks generated by Mockito 5.0.7 from annotations
// in fiscal/test/data/repositories/transaction_repository_impl_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;

import 'package:fiscal/data/datasources/local/transaction_local_data_source.dart'
    as _i5;
import 'package:fiscal/data/datasources/remote/transaction_remote_data_source.dart'
    as _i2;
import 'package:fiscal/data/models/transactions/transaction_model.dart' as _i4;
import 'package:fiscal/domain/enitities/transactions/transaction.dart' as _i6;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: comment_references
// ignore_for_file: unnecessary_parenthesis

// ignore_for_file: prefer_const_constructors

// ignore_for_file: avoid_redundant_argument_values

/// A class which mocks [TransactionRemoteDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockTransactionRemoteDataSource extends _i1.Mock
    implements _i2.TransactionRemoteDataSource {
  MockTransactionRemoteDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<List<_i4.TransactionModel>> getRecentTransactions() =>
      (super.noSuchMethod(Invocation.method(#getRecentTransactions, []),
              returnValue: Future<List<_i4.TransactionModel>>.value(
                  <_i4.TransactionModel>[]))
          as _i3.Future<List<_i4.TransactionModel>>);
  @override
  _i3.Future<Map<String, List<_i4.TransactionModel>>> getAllTransactions(
          String? lastFetchedTransactionID,
          [int? batchSize = 10]) =>
      (super.noSuchMethod(
          Invocation.method(
              #getAllTransactions, [lastFetchedTransactionID, batchSize]),
          returnValue: Future<Map<String, List<_i4.TransactionModel>>>.value(
              <String, List<_i4.TransactionModel>>{})) as _i3
          .Future<Map<String, List<_i4.TransactionModel>>>);
  @override
  _i3.Future<String> addNewTransaction(_i4.TransactionModel? transaction) =>
      (super.noSuchMethod(Invocation.method(#addNewTransaction, [transaction]),
          returnValue: Future<String>.value('')) as _i3.Future<String>);
}

/// A class which mocks [TransactionLocalDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockTransactionLocalDataSource extends _i1.Mock
    implements _i5.TransactionLocalDataSource {
  MockTransactionLocalDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<List<_i6.Transaction>> getRecentTransactions() =>
      (super.noSuchMethod(Invocation.method(#getRecentTransactions, []),
              returnValue:
                  Future<List<_i6.Transaction>>.value(<_i6.Transaction>[]))
          as _i3.Future<List<_i6.Transaction>>);
  @override
  _i3.Future<void> cacheRecentTransactions(
          List<_i6.Transaction>? transactions) =>
      (super.noSuchMethod(
          Invocation.method(#cacheRecentTransactions, [transactions]),
          returnValue: Future<void>.value(null),
          returnValueForMissingStub: Future.value()) as _i3.Future<void>);
  @override
  _i3.Future<void> cacheNewTransaction(_i6.Transaction? transaction) => (super
      .noSuchMethod(Invocation.method(#cacheNewTransaction, [transaction]),
          returnValue: Future<void>.value(null),
          returnValueForMissingStub: Future.value()) as _i3.Future<void>);
}
