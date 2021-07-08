import 'dart:convert';

import 'package:f_logs/f_logs.dart';
import 'package:fiscal/core/core.dart';
import 'package:fiscal/core/error/exceptions.dart';
import 'package:fiscal/data/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TransactionLocalDataSource {
  Future<List<TransactionModel>> getRecentTransactions();

  Future<void> cacheRecentTransactions(List<TransactionModel> transactions);

  Future<void> cacheNewTransaction(TransactionModel transaction);
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  static const String CLASS_NAME = 'TransactionLocalDataSourceImpl';

  final SharedPreferences _preferences;

  TransactionLocalDataSourceImpl(this._preferences);

  @override
  Future<void> cacheNewTransaction(TransactionModel transaction) async {
    FLog.info(text: 'Enter', className: CLASS_NAME, methodName: 'cacheNewTransaction()');

    try {
      final oldTransactions = await getRecentTransactions();
      if (oldTransactions.isNotEmpty && oldTransactions.length > 10) oldTransactions.removeAt(0);

      oldTransactions.add(transaction);
      final newTransactions = oldTransactions.map((t) => TransactionModel.toJSON(t)).toList();
      _preferences.setString(RECENT_TRANS_SHARED_PREF_KEY, json.encode(newTransactions));

      FLog.info(
        text: 'Cached new transaction. [TransactionID: ${transaction.transactionID}]',
        className: CLASS_NAME,
        methodName: 'cacheNewTransaction()',
      );
      FLog.info(text: 'Exit', className: CLASS_NAME, methodName: 'cacheNewTransaction()');
    } catch (e, trace) {
      FLog.error(
        text: 'Exception occurred:',
        className: CLASS_NAME,
        methodName: 'cacheNewTransaction()',
        exception: e,
        stacktrace: trace,
      );
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> cacheRecentTransactions(List<TransactionModel> transactions) async {
    FLog.info(text: 'Enter', className: CLASS_NAME, methodName: 'cacheRecentTransactions()');

    try {
      final newTransactions = transactions.map((t) => TransactionModel.toJSON(t)).toList();
      _preferences.setString(RECENT_TRANS_SHARED_PREF_KEY, json.encode(newTransactions));

      FLog.info(
        text: 'Cached ${newTransactions.length} recent transactions.',
        className: CLASS_NAME,
        methodName: 'cacheRecentTransactions()',
      );
      FLog.info(text: 'Exit', className: CLASS_NAME, methodName: 'cacheRecentTransactions()');
    } catch (e, trace) {
      FLog.error(
        text: 'Exception occurred:',
        className: CLASS_NAME,
        methodName: 'cacheRecentTransactions()',
        exception: e,
        stacktrace: trace,
      );
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<List<TransactionModel>> getRecentTransactions() async {
    FLog.info(text: 'Enter', className: CLASS_NAME, methodName: 'getRecentTransactions()');

    try {
      if (_preferences.getString(RECENT_TRANS_SHARED_PREF_KEY) == null) {
        FLog.info(
          text: 'Exit: No data present. Returning empty results',
          className: CLASS_NAME,
          methodName: 'getRecentTransactions()',
        );

        return <TransactionModel>[];
      }

      final transactions = json.decode(_preferences.getString(RECENT_TRANS_SHARED_PREF_KEY)!) as List<dynamic>;
      final oldTransactions = transactions.map((transactionData) => TransactionModel.fromJSON(transactionData)).toList();

      FLog.info(
        text: 'Returning ${oldTransactions.length} recent transactions from cache.',
        className: CLASS_NAME,
        methodName: 'getRecentTransactions()',
      );
      FLog.info(text: 'Exit', className: CLASS_NAME, methodName: 'getRecentTransactions()');

      return oldTransactions;
    } catch (e, trace) {
      FLog.error(
        text: 'Exception occurred:',
        className: CLASS_NAME,
        methodName: 'getRecentTransactions()',
        exception: e,
        stacktrace: trace,
      );
      throw CacheException(message: e.toString());
    }
  }
}
