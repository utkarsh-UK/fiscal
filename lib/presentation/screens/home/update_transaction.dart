import 'package:fiscal/core/core.dart';
import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/di/locator.dart';
import 'package:fiscal/domain/enitities/entities.dart';
import 'package:fiscal/presentation/provider/transaction_provider.dart';
import 'package:fiscal/presentation/widgets/home/screen_title.dart';
import 'package:fiscal/presentation/widgets/home/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateTransaction extends StatelessWidget {
  final Transaction transaction;

  const UpdateTransaction({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ScreenTitle(
                    key: ValueKey('update_title'),
                    title: 'Update Transaction',
                    actions: [
                      IconButton(
                        key: ValueKey('close_update'),
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
                      key: ValueKey('update_form'),
                      transaction: transaction,
                      isUpdateState: true,
                      onSubmit: (String id, String title, TransactionType type, double amount, int category, int account,
                          DateTime date, String description, String icon, String color, String bankName, int accountNumber) {
                        _updateTransaction(id, title, type, amount, category, account, date, description, icon, color, context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _updateTransaction(String id, String title, TransactionType type, double amount, int category, int account, DateTime date,
      String description, String icon, String color, BuildContext context) {
    final trans = Transaction(
      transactionID: id,
      title: title,
      amount: amount,
      transactionType: type,
      categoryID: category,
      accountID: account,
      date: date,
      description: description,
    );

    context.read<TransactionProvider>().updateTransaction(trans);
  }
}
