import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  String get getFullStringDate => DateFormat.yMMMd().add_jm().format(this);

  String get getDatabaseFormatString => DateFormat('yyyy/MM/dd HH:mm:ss:SSS').format(this);
}