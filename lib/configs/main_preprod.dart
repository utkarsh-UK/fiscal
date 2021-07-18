import 'package:fiscal/flavor_config.dart';
import 'package:fiscal/main_common.dart';

void main() {
  final devConfig = FlavorConfig()
    ..appTitle = 'Fiscal PreProd'
    ..imageLocation = 'assets/';

  mainCommon(devConfig);
}