import 'package:fiscal/domain/enitities/transactions/transaction.dart';
import 'package:fiscal/presentation/provider/transaction_provider.dart';
import 'package:fiscal/presentation/widgets/home/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecentTransactions extends StatefulWidget {
  const RecentTransactions({Key? key}) : super(key: key);

  @override
  _RecentTransactionsState createState() => _RecentTransactionsState();
}

class _RecentTransactionsState extends State<RecentTransactions> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      context.read<TransactionProvider>().getRecentTransactions();
    });
  }

  @override
  Widget build(BuildContext context) => Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          if (provider.status == TransactionStatus.INITIAL || provider.status == TransactionStatus.LOADING)
            return Center(child: CircularProgressIndicator(key: ValueKey('progress')));
          else if (provider.status == TransactionStatus.ERROR)
            return ErrorWidget(provider.error);
          else
            return _buildList(provider.providerData.recentTransactions);
        },
      );

  Widget _buildList(List<Transaction> transactions) => transactions.isEmpty
      ? Center(child: Text('No Transactions Yet', key: ValueKey('empty_trans')))
      : ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: transactions.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext ctx, int index) {
            return TransactionItem(
              key: ValueKey('trans_$index'),
              transaction: transactions[index],
              iconName: transactions[index].category == null ? 'others' : transactions[index].category!.icon,
              iconColor: Color(
                transactions[index].category == null ? 0xFF000000 : int.parse('${transactions[index].category!.color}'),
              ),
              onDeleted: () => context.read<TransactionProvider>().getDailySummary(),
            );
          },
        );
}
