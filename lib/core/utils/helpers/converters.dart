import 'package:fiscal/core/utils/static/enums.dart';

class Converters {
  static String convertTransactionTypeEnum(TransactionType type) => type == TransactionType.INCOME ? 'INCOME' : 'EXPENSE';

  static TransactionType convertTransactionTypeString(String type) =>
      type == 'INCOME' ? TransactionType.INCOME : TransactionType.EXPENSE;

  static String convertAccountTypeEnum(AccountType type) => type == AccountType.SAVINGS ? 'SAVINGS' : 'CURRENT';

  static AccountType convertAccountTypeString(String type) =>
      type == 'SAVINGS' ? AccountType.SAVINGS : AccountType.CURRENT;
}
