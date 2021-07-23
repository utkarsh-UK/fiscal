class CategoryTable {
  static const String TABLE_NAME = 'category';

  //COLUMNS
  static const String id = 'category_id';
  static const String name = 'name';
  static const String icon = 'icon';
  static const String color = 'color';
  static const String createdAt = 'created_at';
  static const String transactionType = 'transaction_type';

  //queries
  static const String income_insert_query = '''
    INSERT INTO ${CategoryTable.TABLE_NAME} (name, icon, color, created_at, transaction_type)
    VALUES ('Allowance', 'allowance', '0xFF81B214', '2021-07-23T14:13:29.104', 'INCOME'),
      ('Salary', 'salary', '0xFF1597BB', '2021-07-23T14:13:29.104', 'INCOME'),
      ('Petty Cash', 'petty_cash', '0xFF28527A', '2021-07-23T14:13:29.104', 'INCOME'),
      ('Bonus', 'bonus', '0xFF822659', '2021-07-23T14:13:29.104', 'INCOME'),
      ('Others', 'others', '0xFF000000', '2021-07-23T14:13:29.104', 'INCOME'),
      ('Dividends', 'investment', '0xFFF21170', '2021-07-23T14:13:29.104', 'INCOME');
    ''';

  static const String expense_insert_query = '''
    INSERT INTO ${CategoryTable.TABLE_NAME} (name, icon, color, created_at, transaction_type)
    VALUES ('Investment', 'investment', '0xFFF21170', '2021-07-23T14:13:29.104', 'EXPENSE'),
      ('Food', 'food', '0xFF6CA414' ,'2021-07-23T14:13:29.104', 'EXPENSE'),
      ('Social Life', 'social_life', '0xFF6930C3', '2021-07-23T14:13:29.104', 'EXPENSE'),
      ('Self Development', 'self_development', '0xFFFECD1A', '2021-07-23T14:13:29.104', 'EXPENSE'),
      ('Travel', 'travel', '0xFF29BB89', '2021-07-23T14:13:29.104', 'EXPENSE'),
      ('Household', 'household', '0xFFE05297', '2021-07-23T14:13:29.104', 'EXPENSE'),
      ('Health', 'health', '0xFFFB3640', '2021-07-23T14:13:29.104', 'EXPENSE'),
      ('Education', 'education', '0xFFFF5200', '2021-07-23T14:13:29.104', 'EXPENSE'),
      ('Gifts', 'gifts', '0xFF6A097D', '2021-07-23T14:13:29.104', 'EXPENSE'),
      ('Others', 'others', '0xFF000000', '2021-07-23T14:13:29.104', 'EXPENSE'),
      ('Donations', 'donations', '0xFFF33825', '2021-07-23T14:13:29.104', 'EXPENSE'),
      ('Transfer', 'transfer', '0xFF8F4F4F', '2021-07-23T14:13:29.104', 'EXPENSE');
    ''';
}
