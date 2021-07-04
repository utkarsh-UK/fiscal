import 'package:fiscal/core/core.dart';
import 'package:fiscal/presentation/screens/home/recent_transactions.dart';
import 'package:fiscal/presentation/widgets/home/transactions_summary.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'Welcome back,\n', style: FiscalTheme.welcomeText),
                    TextSpan(text: 'Utkarsh Kore', style: FiscalTheme.screenTitleText),
                  ],
                ),
                key: ValueKey('onboard_key'),
              ),
              const SizedBox(height: 12.0),
              const TransactionsSummary(key: ValueKey('summary')),
              const SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent Transactions', style: FiscalTheme.sectionHeadingText),
                  InkWell(
                    onTap: () {},
                    splashColor: Colors.grey[400],
                    radius: 30.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 8.0, bottom: 8.0),
                      child: Text(
                        'See All',
                        key: ValueKey('see_all'),
                        style: FiscalTheme.smallButtonText,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              const Expanded(child: const RecentTransactions(key: ValueKey('recent_transactions')))
            ],
          ),
        ),
      ),
    );
  }
}
