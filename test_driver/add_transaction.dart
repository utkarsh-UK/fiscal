import 'package:fiscal/flavor_config.dart';
import 'package:fiscal/main_common.dart' as app;
import 'package:flutter_driver/driver_extension.dart';

void main() {
  //Enable the extension
  enableFlutterDriverExtension();

  //Call main function of the app
  final config = FlavorConfig()
    ..appTitle = 'Fiscal Integration'
    ..imageLocation = 'assets/';
  app.mainCommon(config);
}
