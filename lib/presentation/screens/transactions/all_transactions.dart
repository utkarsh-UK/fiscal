import 'package:fiscal/core/core.dart';
import 'package:fiscal/di/locator.dart';
import 'package:fiscal/presentation/widgets/home/screen_title.dart';
import 'package:fiscal/presentation/widgets/transactions/transactions_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AllTransactions extends StatelessWidget {
  const AllTransactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentMonth = DateFormat('MMMM').format(DateTime.now());
    final currentYear = DateFormat('yyyy').format(DateTime.now());

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
                      onPressed: locator.get<NavigationService>().navigateBack,
                      child: Text('$currentMonth $currentYear', style: FiscalTheme.screenActionTitleText),
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
                TransactionsList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
