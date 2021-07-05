import 'package:fiscal/core/core.dart';
import 'package:fiscal/di/locator.dart';
import 'package:fiscal/presentation/widgets/home/screen_title.dart';
import 'package:fiscal/presentation/widgets/home/transaction_form.dart';
import 'package:flutter/material.dart';

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
                  child: TransactionForm(key: ValueKey('form'), onSubmit: () {}),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
