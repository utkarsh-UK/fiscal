import 'package:equatable/equatable.dart';
import 'package:fiscal/core/utils/static/enums.dart';

class Account extends Equatable {
  final int accountID;
  final int accountNumber;
  final String bankName;
  final double balance;
  final String logo;
  final AccountType accountType;
  final DateTime? createdAt;

  Account({
    required this.accountID,
    required this.accountNumber,
    required this.bankName,
    required this.balance,
    required this.logo,
    this.accountType = AccountType.SAVINGS,
    this.createdAt,
  });

  @override
  List<Object> get props => [accountID, bankName, accountNumber, balance];
}
