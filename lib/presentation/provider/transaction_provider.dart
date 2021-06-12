import 'package:fiscal/core/core.dart';
import 'package:fiscal/core/usecase/usecase.dart';
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
}

class TransactionProviderData {
  List<Transaction> recentTransactions;

  TransactionProviderData({
    this.recentTransactions = const [],
  });
}
