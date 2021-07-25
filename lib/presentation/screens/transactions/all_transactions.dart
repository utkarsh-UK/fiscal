import 'package:fiscal/core/core.dart';
import 'package:fiscal/presentation/provider/transaction_provider.dart';
import 'package:fiscal/presentation/widgets/home/screen_title.dart';
import 'package:fiscal/presentation/widgets/transactions/transactions_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';

class AllTransactions extends StatefulWidget {
  const AllTransactions({Key? key}) : super(key: key);

  @override
  _AllTransactionsState createState() => _AllTransactionsState();
}

class _AllTransactionsState extends State<AllTransactions> {
  late String _currentSelectedMonth;

  @override
  void initState() {
    super.initState();

    final currentMonth = DateFormat('MMMM').format(DateTime.now());
    final currentYear = DateFormat('yyyy').format(DateTime.now());
    _currentSelectedMonth = '$currentMonth $currentYear';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScreenTitle(
                  key: ValueKey('title_all_transactions'),
                  title: 'All Transactions',
                  actions: [
                    TextButton(
                      key: ValueKey('month_selector'),
                      onPressed: () => _selectMonth(context),
                      child: Text(_currentSelectedMonth, style: FiscalTheme.screenActionTitleText),
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
                TransactionsList(key: ValueKey('transaction_list')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _selectMonth(BuildContext context) async {
    final date = await showMonthPicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 1)),
    );

    if (date == null) return;

    final String time = DateFormat('yyyy-MM').format(date);
    setState(() => _currentSelectedMonth = DateFormat('MMMM yyyy').format(date));
    context.read<TransactionProvider>().getAllTransactions(
          lastTransactionID: '',
          timestamp: time,
        );
  }
}
