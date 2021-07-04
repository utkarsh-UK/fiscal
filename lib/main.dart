import 'package:f_logs/f_logs.dart';
import 'package:fiscal/core/core.dart';
import 'package:fiscal/core/utils/routing/navigation_service.dart';
import 'package:fiscal/di/locator.dart' as di;
import 'package:fiscal/presentation/screens/home/landing.dart';
import 'package:flutter/material.dart';

void initLogConfig() {
  LogsConfig config = FLog.getDefaultConfigurations()
    ..isDevelopmentDebuggingEnabled = true
    ..timestampFormat = TimestampFormat.TIME_FORMAT_24_FULL
    ..formatType = FormatType.FORMAT_CUSTOM
    ..fieldOrderFormatCustom = [
      FieldName.TIMESTAMP,
      FieldName.LOG_LEVEL,
      FieldName.CLASSNAME,
      FieldName.METHOD_NAME,
      FieldName.TEXT,
      FieldName.EXCEPTION,
      FieldName.STACKTRACE,
    ]
    ..customOpeningDivider = '['
    ..customClosingDivider = ']';

  FLog.applyConfigurations(config);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  initLogConfig();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fiscal',
      debugShowCheckedModeBanner: false,
      navigatorKey: di.locator.get<NavigationService>().navigatorKey,
      onGenerateRoute: generateRoute,
      home: Landing(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: FiscalTheme.SECONDARY_FONT_SIGNIKA,
        canvasColor: Colors.white,
      ),
    );
  }
}
