class TransactionTable {
  static const String TABLE_NAME = 'transact';

  //COLUMNS
  static const String id = 'transaction_id';
  static const String date = 'date';
  static const String title = 'title';
  static const String description = 'description';
  static const String amount = 'amount';
  static const String transaction_type = 'transaction_type';
  static const String category_id = 'category_id';
  static const String acc_id = 'acc_id';

  static const String income_value = 'INCOME';
  static const String expense_value = 'EXPENSE';
}