class AccountsTable {
  static const String TABLE_NAME = 'accounts';

  //COLUMNS
  static const String id = 'account_id';
  static const String bank_name = 'bank_name';
  static const String balance = 'balance';
  static const String account_type = 'account_type';
  static const String timestamp = 'timestamp';
  static const String account_number = 'account_no';
  static const String logo = 'logo';

  static const String SAVINGS = 'SAVINGS';
  static const String CURRENT = 'CURRENT';

  static const String account_insert_query = '''
    INSERT INTO ${AccountsTable.TABLE_NAME} (bank_name, balance, account_type, timestamp, account_no, logo)
    VALUES ('HDFC Bank', 12056, 'SAVINGS', '2021-07-23T14:13:29.104', 23123141, 'logo'),
    ('Central Bank', 8900, 'SAVINGS', '2021-07-23T14:13:29.104', 676172672, 'logo');
    ''';
}
