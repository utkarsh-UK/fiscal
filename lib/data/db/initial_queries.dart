import 'package:fiscal/core/core.dart';

const String CREATE_CATEGORY_TABLE_QUERY = '''
CREATE TABLE ${CategoryTable.TABLE_NAME} (
  ${CategoryTable.id} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${CategoryTable.name} TEXT NOT NULL,
  ${CategoryTable.icon} TEXT NOT NULL,
  ${CategoryTable.color} TEXT NOT NULL,
  ${CategoryTable.createdAt} TEXT NOT NULL,
  ${CategoryTable.transactionType} CHECK(${CategoryTable.transactionType} IN ('${TransactionTable.income_value}', '${TransactionTable.expense_value}'))
);
''';

const String CREATE_ACCOUNTS_TABLE_QUERY = '''
CREATE TABLE ${AccountsTable.TABLE_NAME} (
  ${AccountsTable.id} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${AccountsTable.bank_name} TEXT NOT NULL,
  ${AccountsTable.balance} REAL NOT NULL,
  ${AccountsTable.account_type} TEXT NOT NULL CHECK(${AccountsTable.account_type} IN ('${AccountsTable.SAVINGS}', '${AccountsTable.CURRENT}')),
  ${AccountsTable.timestamp} TEXT NOT NULL,
  ${AccountsTable.account_number} INTEGER NOT NULL,
  ${AccountsTable.logo} TEXT NOT NULL DEFAULT ""
);
''';
