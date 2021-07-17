import 'package:fiscal/core/core.dart';
import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/di/locator.dart';
import 'package:fiscal/presentation/provider/transaction_provider.dart';
import 'package:fiscal/presentation/widgets/home/screen_title.dart';
import 'package:fiscal/presentation/widgets/home/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddNewTransaction extends StatelessWidget {
  const AddNewTransaction({Key? key}) : super(key: key);

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
                  key: ValueKey('title'),
                  title: 'Add Transaction',
                  actions: [
                    IconButton(
                      key: ValueKey('close'),
                      onPressed: locator.get<NavigationService>().navigateBack,
                      icon: Icon(
                        Icons.close_rounded,
                        color: FiscalTheme.SECONDARY_COLOR,
                        size: 35.0,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                  child: TransactionForm(
                    key: ValueKey('form'),
                    onSubmit: (String title, TransactionType type, double amount, String category, int account, DateTime date,
                        String description) {
                      _addTransaction(title, type, amount, category, account, date, description, context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addTransaction(String title, TransactionType type, double amount, String category, int account, DateTime date,
      String description, BuildContext context) {
    context.read<TransactionProvider>().addNewTransaction(
          title: title,
          amount: amount,
          type: type,
          categoryID: category,
          accountID: account,
          date: date,
          description: description,
        );
  }
}
