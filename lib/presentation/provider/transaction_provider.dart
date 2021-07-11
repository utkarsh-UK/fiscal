import 'package:f_logs/f_logs.dart';
import 'package:fiscal/core/core.dart';
import 'package:fiscal/core/usecase/transaction_param.dart';
import 'package:fiscal/core/usecase/usecase.dart';
import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/domain/enitities/entities.dart';
import 'package:fiscal/domain/usecases/usecases.dart';
import 'package:flutter/foundation.dart';

enum TransactionStatus { REFRESHING, LOADING, COMPLETED, SUMMARY_LOADED, ERROR, INITIAL }

class TransactionProvider extends ChangeNotifier {
  static const String CLASS_NAME = 'TransactionProvider';

  final GetAllTransactions _getAllTransactions;
  final GetRecentTransactions _getRecentTransactions;
  final AddNewTransaction _addNewTransaction;
  final GetDailySummary _getDailySummary;

  TransactionProvider({
    required GetAllTransactions getAllTransactions,
    required GetRecentTransactions getRecentTransactions,
    required AddNewTransaction addNewTransaction,
    required GetDailySummary getDailySummary,
  })  : _getAllTransactions = getAllTransactions,
        _getRecentTransactions = getRecentTransactions,
        _addNewTransaction = addNewTransaction,
        _getDailySummary = getDailySummary;

  TransactionStatus _status = TransactionStatus.INITIAL;
  String _message = '';
  TransactionProviderData data = TransactionProviderData();

  TransactionStatus get status => _status;

  String get error => _message;

  Future<void> getRecentTransactions() async {
    FLog.info(text: 'Enter', className: CLASS_NAME, methodName: 'getRecentTransactions()');

    _status = TransactionStatus.LOADING;
    notifyListeners();

    final failureOrTransactions = await _getRecentTransactions(NoParams());

    failureOrTransactions.fold((failure) {
      _message = Utility.mapFailureToMessage(failure);
      _status = TransactionStatus.ERROR;
      notifyListeners();

      FLog.error(
        text: 'Error message: $_message and status: $_status',
        className: CLASS_NAME,
        methodName: 'getRecentTransactions()',
      );
    }, (fetchedTransactions) {
      data.recentTransactions = fetchedTransactions;
      _status = TransactionStatus.COMPLETED;
      notifyListeners();

      FLog.info(
        text: 'Fetched recent transactions and notified listeners.',
        className: CLASS_NAME,
        methodName: 'getRecentTransactions()',
      );
    });
    FLog.info(text: 'Exit', className: CLASS_NAME, methodName: 'getRecentTransactions()');
  }

  Future<void> getAllTransactions({required String lastTransactionID, required String timestamp}) async {
    FLog.info(text: 'Enter', className: CLASS_NAME, methodName: 'getAllTransactions()');
    FLog.info(text: 'Parameters: [$lastTransactionID], [$timestamp]', className: CLASS_NAME, methodName: 'getAllTransactions()');

    _status = TransactionStatus.LOADING;
    notifyListeners();

    final failureOrTransactions = await _getAllTransactions(
      Params(
        transactionParam: TransactionParam(lastFetchedTransactionID: lastTransactionID, time: timestamp),
      ),
    );

    failureOrTransactions.fold((failure) {
      _message = Utility.mapFailureToMessage(failure);
      _status = TransactionStatus.ERROR;
      notifyListeners();

      FLog.error(
        text: 'Error message: $_message and status: $_status',
        className: CLASS_NAME,
        methodName: 'getAllTransactions()',
      );
    }, (fetchedTransactions) {
      data.allTransactions = [...data.allTransactions, ...fetchedTransactions['data']!];
      _status = TransactionStatus.COMPLETED;
      notifyListeners();

      FLog.info(
        text: 'Fetched all transactions and notified listeners.',
        className: CLASS_NAME,
        methodName: 'getAllTransactions()',
      );
    });
    FLog.info(text: 'Exit', className: CLASS_NAME, methodName: 'getAllTransactions()');
  }

  Future<void> addNewTransaction({
    required String title,
    String description = '',
    required double amount,
    required TransactionType type,
    required String categoryID,
    required int accountID,
    required DateTime date,
  }) async {
    FLog.info(text: 'Enter', className: CLASS_NAME, methodName: 'addNewTransaction()');
    FLog.info(
      text: 'Parameters: [$title], [$description], [$amount], [$type], [$categoryID], [$accountID], [$date]',
      className: CLASS_NAME,
      methodName: 'addNewTransaction()',
    );

    _status = TransactionStatus.LOADING;
    notifyListeners();

    final transaction = Transaction(
      transactionID: '',
      title: title,
      amount: amount,
      transactionType: type,
      categoryID: categoryID,
      accountID: accountID,
      date: date,
      description: description,
    );

    final failureOrTransactions = await _addNewTransaction(
      Params(transactionParam: TransactionParam(transaction: transaction)),
    );

    failureOrTransactions.fold((failure) {
      _message = Utility.mapFailureToMessage(failure);
      _status = TransactionStatus.ERROR;
      notifyListeners();

      FLog.error(
        text: 'Error message: $_message and status: $_status',
        className: CLASS_NAME,
        methodName: 'addNewTransaction()',
      );
    }, (fetchedTransactions) {
      _status = TransactionStatus.COMPLETED;
      notifyListeners();

      FLog.info(
        text: 'Added new transaction and notified listeners.',
        className: CLASS_NAME,
        methodName: 'addNewTransaction()',
      );
    });
    FLog.info(text: 'Exit', className: CLASS_NAME, methodName: 'addNewTransaction()');
  }

  Future<void> getDailySummary() async {
    FLog.info(text: 'Enter', className: CLASS_NAME, methodName: 'getDailySummary()');

    _status = TransactionStatus.REFRESHING;
    notifyListeners();

    final failureOrSummary = await _getDailySummary(NoParams());

    failureOrSummary.fold((failure) {
      _message = Utility.mapFailureToMessage(failure);
      _status = TransactionStatus.ERROR;
      notifyListeners();

      FLog.error(
        text: 'Error message: $_message and status: $_status',
        className: CLASS_NAME,
        methodName: 'getDailySummary()',
      );
    }, (fetchedSummary) {
      data.summary = fetchedSummary;
      _status = TransactionStatus.SUMMARY_LOADED;
      notifyListeners();

      FLog.info(
        text: 'Fetched daily summary and notified listeners.',
        className: CLASS_NAME,
        methodName: 'getDailySummary()',
      );
    });
    FLog.info(text: 'Exit', className: CLASS_NAME, methodName: 'getDailySummary()');
  }
}

class TransactionProviderData {
  List<Transaction> recentTransactions;
  List<Transaction> allTransactions;
  Map<String, Object?> summary;

  TransactionProviderData({
    this.recentTransactions = const [],
    this.allTransactions = const [],
    this.summary = const {},
  });

  set setRecentTransactions(List<Transaction> trans) {
    this.recentTransactions = trans;
  }

  set setAllTransactions(List<Transaction> all) {
    this.allTransactions = all;
  }

  set setRecentTransaction(Map<String, Object?> data) {
    this.summary = data;
  }
}
