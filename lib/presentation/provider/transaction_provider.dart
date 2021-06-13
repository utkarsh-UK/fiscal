import 'package:fiscal/core/core.dart';
import 'package:fiscal/core/usecase/transaction_param.dart';
import 'package:fiscal/core/usecase/usecase.dart';
import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/domain/enitities/entities.dart';
import 'package:fiscal/domain/usecases/usecases.dart';
import 'package:flutter/foundation.dart';

enum TransactionStatus { LOADING, COMPLETED, ERROR }

class TransactionProvider extends ChangeNotifier {
  final GetAllTransactions _getAllTransactions;
  final GetRecentTransactions _getRecentTransactions;
  final AddNewTransaction _addNewTransaction;

  TransactionProvider({
    required GetAllTransactions getAllTransactions,
    required GetRecentTransactions getRecentTransactions,
    required AddNewTransaction addNewTransaction,
  })  : _getAllTransactions = getAllTransactions,
        _getRecentTransactions = getRecentTransactions,
        _addNewTransaction = addNewTransaction;

  late TransactionStatus _status;
  String _message = '';
  TransactionProviderData data = TransactionProviderData();

  TransactionStatus get status => _status;

  String get error => _message;

  Future<void> getRecentTransactions() async {
    _status = TransactionStatus.LOADING;
    notifyListeners();

    final failureOrTransactions = await _getRecentTransactions(NoParams());

    failureOrTransactions.fold((failure) {
      _message = Utility.mapFailureToMessage(failure);
      _status = TransactionStatus.ERROR;
      notifyListeners();
    }, (fetchedTransactions) {
      data.recentTransactions = fetchedTransactions;
      _status = TransactionStatus.COMPLETED;
      notifyListeners();
    });
  }

  Future<void> getAllTransactions({required String lastTransactionID, required String timestamp}) async {
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
    }, (fetchedTransactions) {
      data.allTransactions = [...data.allTransactions, ...fetchedTransactions['data']!];
      _status = TransactionStatus.COMPLETED;
      notifyListeners();
    });
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
    );

    final failureOrTransactions = await _addNewTransaction(
      Params(transactionParam: TransactionParam(transaction: transaction)),
    );

    failureOrTransactions.fold((failure) {
      _message = Utility.mapFailureToMessage(failure);
      _status = TransactionStatus.ERROR;
      notifyListeners();
    }, (fetchedTransactions) {
      _status = TransactionStatus.COMPLETED;
      notifyListeners();
    });
  }
}

class TransactionProviderData {
  List<Transaction> recentTransactions;
  List<Transaction> allTransactions;

  TransactionProviderData({
    this.recentTransactions = const [],
    this.allTransactions = const [],
  });
}
