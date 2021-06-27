import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/domain/enitities/transactions/transaction.dart';
import 'package:fiscal/presentation/widgets/home/transaction_item.dart';
import 'package:flutter/material.dart';

class RecentTransactions extends StatefulWidget {
  const RecentTransactions({Key? key}) : super(key: key);

  @override
  _RecentTransactionsState createState() => _RecentTransactionsState();
}

class _RecentTransactionsState extends State<RecentTransactions> {
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
    Transaction(
        transactionID: '3',
        title: 'Salary Credited',
        amount: 1500.6,
        transactionType: TransactionType.EXPENSE,
        categoryID: '12',
        accountID: 2,
        date: DateTime.now(),
        description: 'First Salary Credited'),
    Transaction(
        transactionID: '4',
        title: 'Funds Transfer',
        amount: 17.6,
        transactionType: TransactionType.INCOME,
        categoryID: '12',
        accountID: 2,
        date: DateTime.now(),
        description: 'Transferred from Accounts'),
    Transaction(
      transactionID: '5',
      title: 'Donation',
      amount: 17.6,
      transactionType: TransactionType.INCOME,
      categoryID: '12',
      accountID: 2,
      date: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) => ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: _transactions.length,
        itemBuilder: (BuildContext ctx, int index) => TransactionItem(
          key: ValueKey('trans_$index'),
          title: _transactions[index].title,
          description: _transactions[index].description,
          transactionType: _transactions[index].transactionType,
          transactionDate: _transactions[index].date,
          amount: _transactions[index].amount,
        ),
      );
}
