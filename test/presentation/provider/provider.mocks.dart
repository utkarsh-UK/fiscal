import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/domain/enitities/entities.dart';
import 'package:fiscal/domain/enitities/transactions/transaction.dart';
import 'package:fiscal/presentation/provider/transaction_provider.dart';
import 'package:mockito/mockito.dart';

class FakeTransactionProviderData extends Fake implements TransactionProviderData {
  final _transactions = [
    Transaction(
        transactionID: '1',
        title: 'Invested in Stocks And Mutual Funds',
        amount: 1765.6,
        transactionType: TransactionType.INCOME,
        categoryID: '12',
        accountID: 2,
        date: DateTime.now(),
        description: 'Investment Description'),
    Transaction(
        transactionID: '2',
        title: 'React Course',
        amount: 2000.6,
        transactionType: TransactionType.EXPENSE,
        categoryID: '12',
        accountID: 2,
        date: DateTime.now(),
        description: 'Bought Udemy Course with long descriptin'),
  ];

  @override
  List<Transaction> get recentTransactions => _transactions;

  @override
  List<Transaction> get allTransactions => _transactions;

  @override
  Map<String, Object> get summary => {'INCOME': '3300', 'EXPENSE': '1500'};
}

class ProviderDataMock extends Mock implements TransactionProviderData {

  @override
  List<Transaction> get recentTransactions => [];

  @override
  List<Transaction> get allTransactions => [];

  @override
  Map<String, Object?> get summary => {'INCOME': '3300', 'EXPENSE': '1500'};

  @override
  set setAllTransactions(List<Transaction> all) {
    return super.noSuchMethod(Invocation.setter(#setAllTransactions, all));
  }

  @override
  set setRecentTransaction(Map<String, Object?> data) {
    return super.noSuchMethod(Invocation.setter(#setRecentTransaction, data));
  }
}

class ProviderMock extends Mock implements TransactionProvider {
  @override
  TransactionProviderData get providerData {
    return super.noSuchMethod(
      Invocation.getter(#providerData),
      returnValue: FakeTransactionProviderData(),
      returnValueForMissingStub: FakeTransactionProviderData(),
    );
  }

  @override
  TransactionStatus get status {
    return super.noSuchMethod(
      Invocation.getter(#status),
      returnValue: TransactionStatus.INITIAL,
      returnValueForMissingStub: TransactionStatus.INITIAL,
    );
  }

  @override
  TransactionProviderData get data {
    return super.noSuchMethod(
      Invocation.getter(#data),
      returnValue: FakeTransactionProviderData(),
      returnValueForMissingStub: FakeTransactionProviderData(),
    );
  }

  @override
  Future<void> getDailySummary() {
    return super.noSuchMethod(
      Invocation.method(#getDailySummary, null),
      returnValue: Future.value(),
      returnValueForMissingStub: Future.value(),
    );
  }

  @override
  Future<void> getRecentTransactions() {
    return super.noSuchMethod(
      Invocation.method(#getRecentTransactions, null),
      returnValue: Future.value(),
      returnValueForMissingStub: Future.value(),
    );
  }

  @override
  Future<List<Category>> getCategories(TransactionType type) {
    return super.noSuchMethod(
      Invocation.method(#getCategories, null),
      returnValue: Future.value(<Category>[]),
      returnValueForMissingStub: Future.value(<Category>[]),
    );
  }
}
