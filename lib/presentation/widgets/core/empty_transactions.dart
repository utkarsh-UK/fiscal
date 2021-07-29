import 'package:fiscal/core/core.dart';
import 'package:fiscal/di/locator.dart';
import 'package:flutter/material.dart';

class EmptyTransactions extends StatelessWidget {
  const EmptyTransactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: SizedBox(
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No Transactions yet.\nGet started by adding transaction.',
              style: FiscalTheme.sectionHeadingText.copyWith(fontSize: 16.0),
              textAlign: TextAlign.center,
              key: ValueKey('empty_state'),
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () => locator.get<NavigationService>().navigateToNamed(ADD_NEW_TRANSACTION),
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(6.0),
                padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                ),
              ),
              child: Text('Add Transaction', style: FiscalTheme.smallButtonText.copyWith(color: FiscalTheme.BACKGROUND_COLOR)),
            )
          ],
        ),
      ),
    );
  }
}
