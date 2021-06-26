import 'package:fiscal/core/core.dart';
import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/domain/enitities/transactions/transaction.dart';
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
    ),
    Transaction(
      transactionID: '2',
      title: 'React Course',
      amount: 2000.6,
      transactionType: TransactionType.EXPENSE,
      categoryID: '12',
      accountID: 2,
      date: DateTime.now(),
    ),
    Transaction(
      transactionID: '3',
      title: 'Salary Credited',
      amount: 1500.6,
      transactionType: TransactionType.EXPENSE,
      categoryID: '12',
      accountID: 2,
      date: DateTime.now(),
    ),
    Transaction(
      transactionID: '4',
      title: 'Funds Transfer',
      amount: 17.6,
      transactionType: TransactionType.INCOME,
      categoryID: '12',
      accountID: 2,
      date: DateTime.now(),
    ),
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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: _transactions.length,
      itemBuilder: (ctx, index) {
        final transaction = _transactions[index];
        final bool isIncome =
            transaction.transactionType == TransactionType.INCOME;

        return Container(
          width: size.width - 16.0,
          decoration: BoxDecoration(
            color: Color(0xFFFAFAFA),
            border: Border.all(
              color: Color(0xFFBABABA),
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          margin: const EdgeInsets.only(bottom: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: size.width * 0.2,
                child: Row(
                  children: [
                    Container(
                      height: 50.0,
                      width: 5.0,
                      decoration: BoxDecoration(
                        color: FiscalTheme.SECONDARY_COLOR,
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    SizedBox(
                      width: 40.0,
                      height: 40.0,
                      child: Placeholder(),
                    ),
                  ],
                ),
              ),
              Container(
                width: size.width * 0.43,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _transactions[index].title,
                      style: const TextStyle(
                        color: FiscalTheme.FONT_DARK_PRIMARY_COLOR,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.clip,
                      softWrap: false,
                    ),
                    Text(
                      _transactions[index].title,
                      style: const TextStyle(
                        color: FiscalTheme.FONT_LIGHT_PRIMARY_COLOR,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.clip,
                    ),
                    Text(
                      Converters.convertTransactionTypeEnum(
                          transaction.transactionType),
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        color: isIncome
                            ? FiscalTheme.POSITIVE_COLOR
                            : FiscalTheme.NEGATIVE_COLOR,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FittedBox(
                        child: Text(
                          transaction.date.toIso8601String(),
                          style: const TextStyle(),
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        '₹' + transaction.amount.toStringAsFixed(2),
                        style: TextStyle(
                          color: isIncome
                              ? FiscalTheme.POSITIVE_COLOR
                              : FiscalTheme.NEGATIVE_COLOR,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
