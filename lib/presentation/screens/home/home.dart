import 'package:fiscal/core/core.dart';
import 'package:fiscal/presentation/screens/home/recent_transactions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
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
                    TextSpan(
                      text: 'Welcome back,\n',
                      style: TextStyle(color: Color(0xFF524E79), fontSize: 24.0, fontWeight: FontWeight.w600),
                    ),
                    TextSpan(
                      text: 'Utkarsh Kore',
                      style: const TextStyle(
                          color: FiscalTheme.FONT_DARK_PRIMARY_COLOR, fontSize: 32.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                key: ValueKey('onboard_key'),
              ),
              const SizedBox(height: 12.0),
              Container(
                key: ValueKey('summary'),
                height: MediaQuery.of(context).size.height * 0.3,
                child: const Placeholder(),
              ),
              const SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Transactions',
                    style: const TextStyle(
                      color: FiscalTheme.FONT_DARK_PRIMARY_COLOR,
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    key: ValueKey('see_all'),
                    onPressed: () {},
                    child: Text(
                      'See All',
                      style: const TextStyle(
                        color: FiscalTheme.ACCENT_COLOR,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const RecentTransactions(
                    key: ValueKey('recent_transactions'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
