import 'package:fiscal/presentation/provider/transaction_provider.dart';
import 'package:fiscal/presentation/widgets/core/empty_transactions.dart';
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

          if (transactions.isEmpty)
            return Container(
              margin: const EdgeInsets.only(top: 30.0),
              child: EmptyTransactions(),
            );

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: transactions.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext ctx, int index) => TransactionItem(
              key: ValueKey('all_trans_$index'),
              transaction: transactions[index],
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
