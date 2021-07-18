import 'package:fiscal/flavor_config.dart';
import 'package:fiscal/main_common.dart';

void main() {
  final integrationConfig = FlavorConfig()
    ..appTitle = 'Fiscal Integration'
    ..imageLocation = 'assets/';

  mainCommon(integrationConfig);
}