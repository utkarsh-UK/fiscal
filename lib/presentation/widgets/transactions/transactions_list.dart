import 'package:fiscal/presentation/provider/transaction_provider.dart';
import 'package:fiscal/presentation/widgets/home/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionsList extends StatelessWidget {
  const TransactionsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        final transactions = provider.data.allTransactions;

        if (transactions.isEmpty) return CircularProgressIndicator();

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: transactions.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext ctx, int index) => TransactionItem(
            key: ValueKey('all_trans_$index'),
            title: transactions[index].title,
            description: transactions[index].description,
            transactionType: transactions[index].transactionType,
            transactionDate: transactions[index].date,
            amount: transactions[index].amount,
          ),
        );
      },
    );
  }
}
