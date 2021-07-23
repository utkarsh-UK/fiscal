import 'package:device_preview/device_preview.dart';
import 'package:f_logs/f_logs.dart';
import 'package:fiscal/core/core.dart';
import 'package:fiscal/core/utils/routing/navigation_service.dart';
import 'package:fiscal/di/locator.dart' as di;
import 'package:fiscal/flavor_config.dart';
import 'package:fiscal/presentation/provider/transaction_provider.dart';
import 'package:fiscal/presentation/screens/home/landing.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    ..customOpeningDivider = ' '
    ..customClosingDivider = ' ';

  FLog.applyConfigurations(config);
}

void mainCommon(FlavorConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  initLogConfig();
  runApp(DevicePreview(builder: (_) => MyApp(config: config), enabled: false));
}

class MyApp extends StatelessWidget {
  final FlavorConfig config;

  const MyApp({Key? key, required this.config}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider<TransactionProvider>(create: (_) => di.locator<TransactionProvider>())],
      child: MaterialApp(
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        title: config.appTitle,
        debugShowCheckedModeBanner: false,
        navigatorKey: di.locator.get<NavigationService>().navigatorKey,
        onGenerateRoute: generateRoute,
        home: Landing(),
        theme: ThemeData(
          primarySwatch: Colors.purple,
          fontFamily: FiscalTheme.SECONDARY_FONT_SIGNIKA,
          canvasColor: Colors.white,
        ),
      ),
    );
  }
}
