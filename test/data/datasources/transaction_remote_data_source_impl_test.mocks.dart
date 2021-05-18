// Mocks generated by Mockito 5.0.7 from annotations
// in fiscal/test/data/datasources/transaction_remote_data_source_impl_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:sqflite_common/sqlite_api.dart' as _i2;
import 'package:sqflite_common/src/sql_builder.dart' as _i4;

// ignore_for_file: comment_references
// ignore_for_file: unnecessary_parenthesis

// ignore_for_file: prefer_const_constructors

// ignore_for_file: avoid_redundant_argument_values

class _FakeBatch extends _i1.Fake implements _i2.Batch {}

/// A class which mocks [Database].
///
/// See the documentation for Mockito's code generation for more information.
class MockDatabase extends _i1.Mock implements _i2.Database {
  MockDatabase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get path =>
      (super.noSuchMethod(Invocation.getter(#path), returnValue: '') as String);
  @override
  bool get isOpen =>
      (super.noSuchMethod(Invocation.getter(#isOpen), returnValue: false)
          as bool);
  @override
  _i3.Future<void> close() => (super.noSuchMethod(Invocation.method(#close, []),
      returnValue: Future<void>.value(null),
      returnValueForMissingStub: Future.value()) as _i3.Future<void>);
  @override
  _i3.Future<T> transaction<T>(_i3.Future<T> Function(_i2.Transaction)? action,
          {bool? exclusive}) =>
      (super.noSuchMethod(
          Invocation.method(#transaction, [action], {#exclusive: exclusive}),
          returnValue: Future<T>.value(null)) as _i3.Future<T>);
  @override
  _i3.Future<int> getVersion() =>
      (super.noSuchMethod(Invocation.method(#getVersion, []),
          returnValue: Future<int>.value(0)) as _i3.Future<int>);
  @override
  _i3.Future<void> setVersion(int? version) =>
      (super.noSuchMethod(Invocation.method(#setVersion, [version]),
          returnValue: Future<void>.value(null),
          returnValueForMissingStub: Future.value()) as _i3.Future<void>);
  @override
  _i3.Future<T> devInvokeMethod<T>(String? method, [dynamic arguments]) =>
      (super.noSuchMethod(
          Invocation.method(#devInvokeMethod, [method, arguments]),
          returnValue: Future<T>.value(null)) as _i3.Future<T>);
  @override
  _i3.Future<T> devInvokeSqlMethod<T>(String? method, String? sql,
          [List<Object?>? arguments]) =>
      (super.noSuchMethod(
          Invocation.method(#devInvokeSqlMethod, [method, sql, arguments]),
          returnValue: Future<T>.value(null)) as _i3.Future<T>);
}

/// A class which mocks [DatabaseExecutor].
///
/// See the documentation for Mockito's code generation for more information.
class MockDatabaseExecutor extends _i1.Mock implements _i2.DatabaseExecutor {
  MockDatabaseExecutor() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<void> execute(String? sql, [List<Object?>? arguments]) =>
      (super.noSuchMethod(Invocation.method(#execute, [sql, arguments]),
          returnValue: Future<void>.value(null),
          returnValueForMissingStub: Future.value()) as _i3.Future<void>);
  @override
  _i3.Future<int> rawInsert(String? sql, [List<Object?>? arguments]) =>
      (super.noSuchMethod(Invocation.method(#rawInsert, [sql, arguments]),
          returnValue: Future<int>.value(0)) as _i3.Future<int>);
  @override
  _i3.Future<int> insert(String? table, Map<String, Object?>? values,
          {String? nullColumnHack, _i4.ConflictAlgorithm? conflictAlgorithm}) =>
      (super.noSuchMethod(
          Invocation.method(#insert, [
            table,
            values
          ], {
            #nullColumnHack: nullColumnHack,
            #conflictAlgorithm: conflictAlgorithm
          }),
          returnValue: Future<int>.value(0)) as _i3.Future<int>);
  @override
  _i3.Future<List<Map<String, Object?>>> query(String? table,
          {bool? distinct,
          List<String>? columns,
          String? where,
          List<Object?>? whereArgs,
          String? groupBy,
          String? having,
          String? orderBy,
          int? limit,
          int? offset}) =>
      (super.noSuchMethod(
              Invocation.method(#query, [
                table
              ], {
                #distinct: distinct,
                #columns: columns,
                #where: where,
                #whereArgs: whereArgs,
                #groupBy: groupBy,
                #having: having,
                #orderBy: orderBy,
                #limit: limit,
                #offset: offset
              }),
              returnValue: Future<List<Map<String, Object?>>>.value(
                  <Map<String, Object?>>[]))
          as _i3.Future<List<Map<String, Object?>>>);
  @override
  _i3.Future<List<Map<String, Object?>>> rawQuery(String? sql,
          [List<Object?>? arguments]) =>
      (super.noSuchMethod(Invocation.method(#rawQuery, [sql, arguments]),
              returnValue: Future<List<Map<String, Object?>>>.value(
                  <Map<String, Object?>>[]))
          as _i3.Future<List<Map<String, Object?>>>);
  @override
  _i3.Future<int> rawUpdate(String? sql, [List<Object?>? arguments]) =>
      (super.noSuchMethod(Invocation.method(#rawUpdate, [sql, arguments]),
          returnValue: Future<int>.value(0)) as _i3.Future<int>);
  @override
  _i3.Future<int> update(String? table, Map<String, Object?>? values,
          {String? where,
          List<Object?>? whereArgs,
          _i4.ConflictAlgorithm? conflictAlgorithm}) =>
      (super.noSuchMethod(
          Invocation.method(#update, [
            table,
            values
          ], {
            #where: where,
            #whereArgs: whereArgs,
            #conflictAlgorithm: conflictAlgorithm
          }),
          returnValue: Future<int>.value(0)) as _i3.Future<int>);
  @override
  _i3.Future<int> rawDelete(String? sql, [List<Object?>? arguments]) =>
      (super.noSuchMethod(Invocation.method(#rawDelete, [sql, arguments]),
          returnValue: Future<int>.value(0)) as _i3.Future<int>);
  @override
  _i3.Future<int> delete(String? table,
          {String? where, List<Object?>? whereArgs}) =>
      (super.noSuchMethod(
          Invocation.method(
              #delete, [table], {#where: where, #whereArgs: whereArgs}),
          returnValue: Future<int>.value(0)) as _i3.Future<int>);
  @override
  _i2.Batch batch() => (super.noSuchMethod(Invocation.method(#batch, []),
      returnValue: _FakeBatch()) as _i2.Batch);
}
