import 'package:fiscal/core/utils/helpers/converters.dart';
import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/core/utils/tables/accounts_table.dart';
import 'package:fiscal/core/utils/tables/transaction_table.dart';
import 'package:fiscal/domain/enitities/core/account.dart';

class AccountModel extends Account {
  final int accountID;
  final int accountNumber;
  final String bankName;
  final double balance;
  final String logo;
  final AccountType accountType;
  final DateTime? createdAt;

  AccountModel({
    required this.accountID,
    required this.accountNumber,
    required this.bankName,
    required this.balance,
    required this.logo,
    this.accountType = AccountType.SAVINGS,
    this.createdAt,
  }) : super(
          accountID: accountID,
          accountNumber: accountNumber,
          balance: balance,
          logo: logo,
          bankName: bankName,
          accountType: accountType,
          createdAt: createdAt,
        );

  factory AccountModel.fromQueryResult(Map<String, Object?> data) {
    return AccountModel(
      accountID: int.parse('${data[AccountsTable.id]}'),
      accountNumber: int.parse('${data[AccountsTable.account_number]}'),
      bankName: '${data[AccountsTable.bank_name]}',
      logo: '${data[AccountsTable.logo]}',
      balance: num.parse('${data[AccountsTable.balance]}').toDouble(),
      accountType: Converters.convertAccountTypeString('${data[AccountsTable.account_type]}'),
      createdAt: DateTime.parse('${data[AccountsTable.timestamp] ?? DateTime.now()}'),
    );
  }

  factory AccountModel.fromJSON(Map<String, dynamic> data) {
    return AccountModel(
      accountID: int.parse('${data[TransactionTable.acc_id]}'),
      accountNumber: int.parse('${data[AccountsTable.account_number]}'),
      bankName: '${data[AccountsTable.bank_name]}',
      balance: -1,
      logo: '',
      accountType: data[AccountsTable.account_type] == null
          ? AccountType.SAVINGS
          : Converters.convertAccountTypeString('${data[AccountsTable.account_type]}'),
      createdAt: DateTime.parse('${data[AccountsTable.timestamp] ?? DateTime.now()}'),
    );
  }

  factory AccountModel.fromTransactionQueryResult(Map<String, Object?> data) {
    return AccountModel(
      accountID: int.parse('${data[AccountsTable.id]}'),
      bankName: '${data[AccountsTable.bank_name]}',
      accountNumber: int.parse('${data[AccountsTable.account_number]}'),
      createdAt: DateTime.now(),
      logo: '${data[AccountsTable.logo]}',
      balance: -1,
      accountType: AccountType.SAVINGS,
    );
  }

  static Map<String, Object?> toQuery(AccountModel model) => {
        AccountsTable.account_number: model.accountNumber,
        AccountsTable.bank_name: model.bankName,
        AccountsTable.account_type: Converters.convertAccountTypeEnum(model.accountType),
        AccountsTable.logo: model.logo,
        AccountsTable.balance: model.balance,
        AccountsTable.timestamp: model.createdAt == null ? DateTime.now().toIso8601String() : model.createdAt!.toIso8601String(),
      };

  static Map<String, dynamic> toJSON(AccountModel model) => {
        AccountsTable.id: model.accountID,
        AccountsTable.account_number: model.accountNumber,
        AccountsTable.bank_name: model.bankName,
        AccountsTable.account_type: Converters.convertAccountTypeEnum(model.accountType),
        AccountsTable.logo: model.logo,
        AccountsTable.balance: model.balance,
        AccountsTable.timestamp: model.createdAt == null ? DateTime.now().toIso8601String() : model.createdAt!.toIso8601String(),
      };
}
