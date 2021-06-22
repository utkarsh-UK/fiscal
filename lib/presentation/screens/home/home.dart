import 'package:fiscal/core/core.dart';
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
                      style: TextStyle(color: FiscalTheme.FONT_DARK_PRIMARY_COLOR, fontSize: 32.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                key: ValueKey('onboard_key'),
              ),
              Placeholder(),
            ],
          ),
        ),
      ),
    );
  }
}
