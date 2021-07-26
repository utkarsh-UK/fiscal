import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseMock extends Mock implements Database {
  @override
  Future<List<Map<String, Object?>>> rawQuery(String sql, [List<Object?>? arguments]) {
    return super.noSuchMethod(Invocation.method(#rawQuery, null), returnValue: Future<List<Map<String, Object?>>>.value([]));
  }

  @override
  Future<int> insert(String table, Map<String, Object?>? values, {String? nullColumnHack, ConflictAlgorithm? conflictAlgorithm}) {
    return super.noSuchMethod(
        Invocation.method(
          #insert,
          [table, values],
          {#nullColumnHack: nullColumnHack, #conflictAlgorithm: conflictAlgorithm},
        ),
        returnValueForMissingStub: Future<int>.value(1),
        returnValue: Future<int>.value(1));
  }

  @override
  Future<int> delete(String table, {String? where, List<Object?>? whereArgs}) {
    return super.noSuchMethod(
        Invocation.method(
          #delete,
          [table],
          {#where: where, #whereArgs: whereArgs},
        ),
        returnValueForMissingStub: Future<int>.value(1),
        returnValue: Future<int>.value(1));
  }

  @override
  Future<int> update(String table, Map<String, Object?> values,
      {String? where, List<Object?>? whereArgs, ConflictAlgorithm? conflictAlgorithm}) {
    return super.noSuchMethod(
        Invocation.method(
          #update,
          [table, values],
          {#where: where, #whereArgs: whereArgs,#conflictAlgorithm: conflictAlgorithm},
        ),
        returnValueForMissingStub: Future<int>.value(1),
        returnValue: Future<int>.value(1));
  }
}
