import 'package:fiscal/core/core.dart';
import 'package:fiscal/presentation/screens/home/recent_transactions.dart';
import 'package:fiscal/presentation/widgets/home/transactions_summary.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
                    TextSpan(
                      text: 'Welcome back,\n',
                      style: TextStyle(color: Color(0xFF524E79), fontSize: 20.0, fontWeight: FontWeight.w600),
                    ),
                    TextSpan(
                      text: 'Utkarsh Kore',
                      style: const TextStyle(
                          color: FiscalTheme.FONT_DARK_PRIMARY_COLOR, fontSize: 28.0, fontWeight: FontWeight.bold),
                    ),
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
                  const Text(
                    'Recent Transactions',
                    style: const TextStyle(
                      color: FiscalTheme.FONT_DARK_PRIMARY_COLOR,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    splashColor: Colors.grey[400],
                    radius: 30.0,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 12.0,
                        top: 8.0,
                        bottom: 8.0,
                      ),
                      child: Text(
                        'See All',
                        key: ValueKey('see_all'),
                        style: const TextStyle(
                          color: FiscalTheme.ACCENT_COLOR,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              const Expanded(
                child: const RecentTransactions(
                  key: ValueKey('recent_transactions'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
