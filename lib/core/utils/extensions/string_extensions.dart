extension CapExtension on String {
  String get titleCase =>
      '${this[0].toUpperCase()}${this.substring(1).toLowerCase()}';
}
