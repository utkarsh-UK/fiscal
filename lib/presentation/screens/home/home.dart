import 'dart:ui';

import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text(
          'Welcome to Fiscal',
          style: TextStyle(fontFamily: 'Patua One'),
        ),
      ),
    );
  }
}
