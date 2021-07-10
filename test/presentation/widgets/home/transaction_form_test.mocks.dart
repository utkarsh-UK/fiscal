// Mocks generated by Mockito 5.0.7 from annotations
// in fiscal/test/presentation/widgets/home/transaction_form_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;
import 'dart:ui' as _i5;

import 'package:fiscal/core/utils/static/enums.dart' as _i4;
import 'package:fiscal/domain/enitities/transactions/transaction.dart' as _i6;
import 'package:fiscal/presentation/provider/transaction_provider.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: comment_references
// ignore_for_file: unnecessary_parenthesis

// ignore_for_file: prefer_const_constructors

// ignore_for_file: avoid_redundant_argument_values

class _FakeTransactionProviderData extends _i1.Fake
    implements _i2.TransactionProviderData {}

/// A class which mocks [TransactionProvider].
///
/// See the documentation for Mockito's code generation for more information.
class MockTransactionProvider extends _i1.Mock
    implements _i2.TransactionProvider {
  MockTransactionProvider() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.TransactionProviderData get data =>
      (super.noSuchMethod(Invocation.getter(#data),
              returnValue: _FakeTransactionProviderData())
          as _i2.TransactionProviderData);
  @override
  set data(_i2.TransactionProviderData? _data) =>
      super.noSuchMethod(Invocation.setter(#data, _data),
          returnValueForMissingStub: null);
  @override
  _i2.TransactionStatus get status => (super.noSuchMethod(
      Invocation.getter(#status),
      returnValue: _i2.TransactionStatus.REFRESHING) as _i2.TransactionStatus);
  @override
  String get error =>
      (super.noSuchMethod(Invocation.getter(#error), returnValue: '')
          as String);
  @override
  bool get hasListeners =>
      (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false)
          as bool);
  @override
  _i3.Future<void> getRecentTransactions() =>
      (super.noSuchMethod(Invocation.method(#getRecentTransactions, []),
          returnValue: Future<void>.value(null),
          returnValueForMissingStub: Future.value()) as _i3.Future<void>);
  @override
  _i3.Future<void> getAllTransactions(
          {String? lastTransactionID, String? timestamp}) =>
      (super.noSuchMethod(
          Invocation.method(#getAllTransactions, [],
              {#lastTransactionID: lastTransactionID, #timestamp: timestamp}),
          returnValue: Future<void>.value(null),
          returnValueForMissingStub: Future.value()) as _i3.Future<void>);
  @override
  _i3.Future<void> addNewTransaction(
          {String? title,
          String? description = r'',
          double? amount,
          _i4.TransactionType? type,
          String? categoryID,
          int? accountID,
          DateTime? date}) =>
      (super.noSuchMethod(
          Invocation.method(#addNewTransaction, [], {
            #title: title,
            #description: description,
            #amount: amount,
            #type: type,
            #categoryID: categoryID,
            #accountID: accountID,
            #date: date
          }),
          returnValue: Future<void>.value(null),
          returnValueForMissingStub: Future.value()) as _i3.Future<void>);
  @override
  _i3.Future<void> getDailySummary() =>
      (super.noSuchMethod(Invocation.method(#getDailySummary, []),
          returnValue: Future<void>.value(null),
          returnValueForMissingStub: Future.value()) as _i3.Future<void>);
  @override
  void addListener(_i5.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#addListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void removeListener(_i5.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#removeListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  void notifyListeners() =>
      super.noSuchMethod(Invocation.method(#notifyListeners, []),
          returnValueForMissingStub: null);
}

/// A class which mocks [TransactionProviderData].
///
/// See the documentation for Mockito's code generation for more information.
class MockTransactionProviderData extends _i1.Mock
    implements _i2.TransactionProviderData {
  MockTransactionProviderData() {
    _i1.throwOnMissingStub(this);
  }

  @override
  List<_i6.Transaction> get recentTransactions =>
      (super.noSuchMethod(Invocation.getter(#recentTransactions),
          returnValue: <_i6.Transaction>[]) as List<_i6.Transaction>);
  @override
  set recentTransactions(List<_i6.Transaction>? _recentTransactions) => super
      .noSuchMethod(Invocation.setter(#recentTransactions, _recentTransactions),
          returnValueForMissingStub: null);
  @override
  List<_i6.Transaction> get allTransactions =>
      (super.noSuchMethod(Invocation.getter(#allTransactions),
          returnValue: <_i6.Transaction>[]) as List<_i6.Transaction>);
  @override
  set allTransactions(List<_i6.Transaction>? _allTransactions) =>
      super.noSuchMethod(Invocation.setter(#allTransactions, _allTransactions),
          returnValueForMissingStub: null);
  @override
  Map<String, Object?> get summary =>
      (super.noSuchMethod(Invocation.getter(#summary),
          returnValue: <String, Object?>{}) as Map<String, Object?>);
  @override
  set summary(Map<String, Object?>? _summary) =>
      super.noSuchMethod(Invocation.setter(#summary, _summary),
          returnValueForMissingStub: null);
  @override
  set setRecentTransactions(List<_i6.Transaction>? trans) =>
      super.noSuchMethod(Invocation.setter(#setRecentTransactions, trans),
          returnValueForMissingStub: null);
  @override
  set setAllTransactions(List<_i6.Transaction>? all) =>
      super.noSuchMethod(Invocation.setter(#setAllTransactions, all),
          returnValueForMissingStub: null);
  @override
  set setRecentTransaction(Map<String, Object?>? data) =>
      super.noSuchMethod(Invocation.setter(#setRecentTransaction, data),
          returnValueForMissingStub: null);
}
