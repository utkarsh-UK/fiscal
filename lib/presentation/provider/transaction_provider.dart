import 'package:f_logs/f_logs.dart';
import 'package:fiscal/core/core.dart';
import 'package:fiscal/core/usecase/transaction_param.dart';
import 'package:fiscal/core/usecase/usecase.dart';
import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/domain/enitities/entities.dart';
import 'package:fiscal/domain/usecases/core/get_accounts.dart';
import 'package:fiscal/domain/usecases/core/get_categories.dart';
import 'package:fiscal/domain/usecases/usecases.dart';
import 'package:flutter/foundation.dart' hide Category;

enum TransactionStatus {
  REFRESHING,
  LOADING,
  COMPLETED,
  ADDED,
  SUMMARY_LOADED,
  ERROR,
  INITIAL,
  RECENT_TRANS_ERR,
  ALL_TRANS_ERR,
  ADD_TRANS_ERR,
  SUMMARY_ERR,
  DELETING,
  DELETED,
  TRANS_DELETE_ERR,
  UPDATING,
  UPDATED,
  TRANS_UPDATE_ERR,
}

class TransactionProvider extends ChangeNotifier {
  static const String CLASS_NAME = 'TransactionProvider';

  final GetAllTransactions _getAllTransactions;
  final GetRecentTransactions _getRecentTransactions;
  final AddNewTransaction _addNewTransaction;
  final GetDailySummary _getDailySummary;
  final GetCategories _getCategories;
  final DeleteTransaction _deleteTransaction;
  final UpdateTransaction _updateTransaction;
  final GetAccounts _getAccounts;

  TransactionProvider({
    required GetAllTransactions getAllTransactions,
    required GetRecentTransactions getRecentTransactions,
    required AddNewTransaction addNewTransaction,
    required GetDailySummary getDailySummary,
    required GetCategories getCategories,
    required DeleteTransaction deleteTransaction,
    required UpdateTransaction updateTransaction,
    required GetAccounts getAccounts,
  })  : _getAllTransactions = getAllTransactions,
        _getRecentTransactions = getRecentTransactions,
        _addNewTransaction = addNewTransaction,
        _getDailySummary = getDailySummary,
        _getCategories = getCategories,
        _deleteTransaction = deleteTransaction,
        _updateTransaction = updateTransaction,
        _getAccounts = getAccounts;

  TransactionStatus _status = TransactionStatus.INITIAL;
  String _message = '';
  TransactionProviderData providerData = TransactionProviderData();

  TransactionProviderData get data => providerData;

  TransactionStatus get status => _status;

  String get error => _message;

  Future<void> getRecentTransactions() async {
    FLog.info(text: 'Enter', className: CLASS_NAME, methodName: 'getRecentTransactions()');

    _status = TransactionStatus.LOADING;
    notifyListeners();

    final failureOrTransactions = await _getRecentTransactions(NoParams());

    failureOrTransactions.fold((failure) {
      _message = Utility.mapFailureToMessage(failure);
      _status = TransactionStatus.RECENT_TRANS_ERR;
      notifyListeners();

      FLog.error(
        text: 'Error message: $_message and status: $_status',
        className: CLASS_NAME,
        methodName: 'getRecentTransactions()',
      );
    }, (fetchedTransactions) {
      providerData.recentTransactions = fetchedTransactions;
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

    if (lastTransactionID.isEmpty) providerData.allTransactions = [];
    _status = TransactionStatus.LOADING;
    notifyListeners();

    final failureOrTransactions = await _getAllTransactions(
      Params(
        transactionParam: TransactionParam(lastFetchedTransactionID: lastTransactionID, time: timestamp),
      ),
    );

    failureOrTransactions.fold((failure) {
      _message = Utility.mapFailureToMessage(failure);
      _status = TransactionStatus.ALL_TRANS_ERR;
      notifyListeners();

      FLog.error(
        text: 'Error message: $_message and status: $_status',
        className: CLASS_NAME,
        methodName: 'getAllTransactions()',
      );
    }, (fetchedTransactions) {
      providerData.allTransactions = [...providerData.allTransactions, ...fetchedTransactions['data']!];
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
    required int categoryID,
    required int accountID,
    required DateTime date,
    required String icon,
    required String color,
  }) async {
    FLog.info(text: 'Enter', className: CLASS_NAME, methodName: 'addNewTransaction()');
    FLog.info(
      text: 'Parameters: [$title], [$description], [$amount], [$type], [$categoryID], [$accountID], [${date.getFullStringDate}]'
          ' [$icon] [$color]',
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
      category: Category(categoryID: categoryID, name: '', icon: icon, color: color),
    );

    final failureOrTransactions = await _addNewTransaction(
      Params(transactionParam: TransactionParam(transaction: transaction)),
    );

    failureOrTransactions.fold((failure) {
      _message = Utility.mapFailureToMessage(failure);
      _status = TransactionStatus.ADD_TRANS_ERR;
      notifyListeners();

      FLog.error(
        text: 'Error message: $_message and status: $_status',
        className: CLASS_NAME,
        methodName: 'addNewTransaction()',
      );
    }, (fetchedTransactions) {
      _status = TransactionStatus.ADDED;
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
      _status = TransactionStatus.SUMMARY_ERR;
      notifyListeners();

      FLog.error(
        text: 'Error message: $_message and status: $_status',
        className: CLASS_NAME,
        methodName: 'getDailySummary()',
      );
    }, (fetchedSummary) {
      providerData.summary = fetchedSummary;
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

  Future<void> deleteTransaction(int transactionID) async {
    FLog.info(text: 'Enter: ID [$transactionID]', className: CLASS_NAME, methodName: 'deleteTransaction()');

    _status = TransactionStatus.DELETING;
    notifyListeners();

    final failureOrDeleted = await _deleteTransaction(Params(transactionParam: TransactionParam(transactionID: transactionID)));

    failureOrDeleted.fold((failure) {
      _message = Utility.mapFailureToMessage(failure);
      _status = TransactionStatus.TRANS_DELETE_ERR;
      notifyListeners();

      FLog.error(
        text: 'Error message: $_message and status: $_status',
        className: CLASS_NAME,
        methodName: 'deleteTransaction()',
      );
    }, (isDeleted) {
      if (isDeleted) {
        providerData.allTransactions.removeWhere((t) => t.transactionID == '$transactionID');
        providerData.recentTransactions.removeWhere((t) => t.transactionID == '$transactionID');
      }
      _status = TransactionStatus.DELETED;
      notifyListeners();

      FLog.info(
        text: 'Deleted transaction and notified listeners.',
        className: CLASS_NAME,
        methodName: 'deleteTransaction()',
      );
    });
    FLog.info(text: 'Exit', className: CLASS_NAME, methodName: 'deleteTransaction()');
  }

  Future<void> updateTransaction(Transaction transaction) async {
    FLog.info(text: 'Enter:', className: CLASS_NAME, methodName: 'updateTransaction()');

    _status = TransactionStatus.UPDATING;
    notifyListeners();

    final failureOrUpdated = await _updateTransaction(
      Params(transactionParam: TransactionParam(transaction: transaction)),
    );

    failureOrUpdated.fold((failure) {
      _message = Utility.mapFailureToMessage(failure);
      _status = TransactionStatus.TRANS_UPDATE_ERR;
      notifyListeners();

      FLog.error(
        text: 'Error message: $_message and status: $_status',
        className: CLASS_NAME,
        methodName: 'updateTransaction()',
      );
    }, (isUpdated) {
      // if (isUpdated) {
      //   int allTransIndex = providerData.allTransactions.indexWhere((t) => t.transactionID == transaction.transactionID);
      //   int recentTransIndex = providerData.recentTransactions.indexWhere((t) => t.transactionID == transaction.transactionID);
      //
      //   if (allTransIndex != -1) {
      //     final category = providerData.allTransactions.firstWhere((t) => t.transactionID == transaction.transactionID).category;
      //     final model = TransactionModel.fromTransaction(transaction, categoryModel: category as CategoryModel);
      //     providerData.allTransactions.removeWhere((t) => t.transactionID == '${transaction.transactionID}');
      //     providerData.allTransactions.insert(allTransIndex, model);
      //   }
      //
      //   if (recentTransIndex != -1) {
      //     final category =
      //         providerData.recentTransactions.firstWhere((t) => t.transactionID == transaction.transactionID).category;
      //     print(category.toString());
      //     final model = TransactionModel.fromTransaction(transaction, categoryModel: category as CategoryModel);
      //     providerData.recentTransactions.removeWhere((t) => t.transactionID == '${transaction.transactionID}');
      //     providerData.recentTransactions.insert(recentTransIndex, model);
      //   }
      // }
      _status = TransactionStatus.UPDATED;
      notifyListeners();

      FLog.info(
        text: 'Updated transaction and notified listeners.',
        className: CLASS_NAME,
        methodName: 'updateTransaction()',
      );
    });
    FLog.info(text: 'Exit', className: CLASS_NAME, methodName: 'updateTransaction()');
  }

  Future<List<Category>> getCategories(TransactionType type) async {
    late List<Category> categories;

    FLog.info(text: 'Enter', className: CLASS_NAME, methodName: 'getCategories()');

    final failureOrCategories = await _getCategories(Params(transactionParam: TransactionParam(transactionType: type)));

    failureOrCategories.fold((failure) {
      categories = [];

      FLog.error(
        text: 'Error message: $_message and status: $_status',
        className: CLASS_NAME,
        methodName: 'getCategories()',
      );
    }, (fetchedCategories) {
      categories = fetchedCategories;

      FLog.info(
        text: 'Fetched categories and notified listeners.',
        className: CLASS_NAME,
        methodName: 'getCategories()',
      );
    });
    FLog.info(text: 'Exit', className: CLASS_NAME, methodName: 'getCategories()');

    return categories;
  }

  Future<List<Account>> getAccounts() async {
    late List<Account> accounts;

    FLog.info(text: 'Enter', className: CLASS_NAME, methodName: 'getAccounts()');

    final failureOrAccounts = await _getAccounts(NoParams());

    failureOrAccounts.fold((failure) {
      accounts = [];

      FLog.error(
        text: 'Error message: $_message and status: $_status',
        className: CLASS_NAME,
        methodName: 'getAccounts()',
      );
    }, (fetchedAccounts) {
      accounts = fetchedAccounts;

      FLog.info(
        text: 'Fetched accounts and notified listeners.',
        className: CLASS_NAME,
        methodName: 'getAccounts()',
      );
    });
    FLog.info(text: 'Exit', className: CLASS_NAME, methodName: 'getAccounts()');

    return accounts;
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
