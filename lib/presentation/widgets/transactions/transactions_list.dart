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
        if (provider.status == TransactionStatus.LOADING)
          return CircularProgressIndicator(key: ValueKey('progress'));
        else if (provider.status == TransactionStatus.ERROR)
          return ErrorWidget(provider.error);
        else if (provider.status == TransactionStatus.COMPLETED || provider.status == TransactionStatus.DELETED) {
          final transactions = provider.providerData.allTransactions;

          if (transactions.isEmpty) return Center(child: Text('No transactions'));

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: transactions.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext ctx, int index) => TransactionItem(
              key: ValueKey('all_trans_$index'),
              transactionID: num.parse(transactions[index].transactionID).toInt(),
              title: transactions[index].title,
              description: transactions[index].description,
              transactionType: transactions[index].transactionType,
              transactionDate: transactions[index].date,
              amount: transactions[index].amount,
              iconName: transactions[index].category == null ? 'others' : transactions[index].category!.icon,
              iconColor: Color(
                transactions[index].category == null ? 0xFF000000 : int.parse('${transactions[index].category!.color}'),
              ),
            ),
          );
        } else
          return SizedBox.shrink();
      },
    );
  }
}
