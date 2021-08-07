import '../flavor_config.dart';
import '../main_common.dart';

void main() {
  final devConfig = FlavorConfig()
      ..appTitle = 'Fiscal Dev'
      ..imageLocation = 'assets/';
  
  mainCommon(devConfig);
}