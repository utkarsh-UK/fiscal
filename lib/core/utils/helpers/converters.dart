import 'package:fiscal/core/utils/static/enums.dart';

class Converters {
  static String convertTransactionTypeEnum(TransactionType type) => type == TransactionType.INCOME
      ? 'INCOME'
      : 'EXPEN'
          'SE';

  static TransactionType convertTransactionTypeString(String type) =>
      type == 'INCOME' ? TransactionType.INCOME : TransactionType.EXPENSE;
}
