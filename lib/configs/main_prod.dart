import 'package:fiscal/flavor_config.dart';
import 'package:fiscal/main_common.dart';

void main() {
  final devConfig = FlavorConfig()
    ..appTitle = 'Fiscal'
    ..imageLocation = 'assets/';

  mainCommon(devConfig);
}