import 'package:fiscal/core/utils/static/enums.dart';

class Converters {
  String convertTransactionTypeEnum(TransactionType type) => type == TransactionType.INCOME ? 'INCOME' : 'EXPENSE';
}
