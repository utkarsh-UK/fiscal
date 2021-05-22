import 'dart:convert';

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
  final SharedPreferences _preferences;

  TransactionLocalDataSourceImpl(this._preferences);

  @override
  Future<void> cacheNewTransaction(TransactionModel transaction) async {
    try {
    final transactions = json.decode(_preferences.getString(RECENT_TRANS_SHARED_PREF_KEY)!) as List<dynamic>;
    final oldTransactions = transactions.map((transactionData) => TransactionModel.fromJSON(transactionData)).toList();
    oldTransactions.removeAt(0);

    oldTransactions.add(transaction);
    final newTransactions = oldTransactions.map((t) => TransactionModel.toJSON(t)).toList();
    _preferences.setString(RECENT_TRANS_SHARED_PREF_KEY, json.encode(newTransactions));
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> cacheRecentTransactions(List<TransactionModel> transactions) {
    // TODO: implement cacheRecentTransactions
    throw UnimplementedError();
  }

  @override
  Future<List<TransactionModel>> getRecentTransactions() {
    // TODO: implement getRecentTransactions
    throw UnimplementedError();
  }
}
