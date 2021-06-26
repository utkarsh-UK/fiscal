import 'package:fiscal/core/core.dart';
import 'package:fiscal/di/locator.dart' as di;
import 'package:fiscal/presentation/screens/home/landing.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fiscal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: FiscalTheme.SECONDARY_FONT_SIGNIKA,
        canvasColor: Colors.white
      ),
      home: Landing(),
    );
  }
}