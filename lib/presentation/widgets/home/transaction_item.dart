import 'package:fiscal/core/core.dart';
import 'package:fiscal/core/utils/static/enums.dart';
import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  final String title;
  final String? description;
  final TransactionType transactionType;
  final DateTime transactionDate;
  final double amount;

  const TransactionItem({
    Key? key,
    required this.title,
    required this.description,
    required this.transactionType,
    required this.transactionDate,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isIncome = transactionType == TransactionType.INCOME;

    return Container(
      width: size.width - 16.0,
      decoration: BoxDecoration(
        color: Color(0xFFFAFAFA),
        border: Border.all(
          color: Color(0xFFBABABA),
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      margin: const EdgeInsets.only(bottom: 18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: size.width * 0.2,
            child: Row(
              children: [
                Container(
                  height: 50.0,
                  width: 5.0,
                  decoration: BoxDecoration(
                    color: FiscalTheme.SECONDARY_COLOR,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
                const SizedBox(width: 10.0),
                const SizedBox(
                  width: 40.0,
                  height: 40.0,
                  child: Placeholder(key: ValueKey('icon')),
                ),
              ],
            ),
          ),
          Container(
            width: size.width * 0.43,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  key: ValueKey('title'),
                  style: const TextStyle(
                    color: FiscalTheme.FONT_DARK_PRIMARY_COLOR,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.clip,
                  softWrap: false,
                ),
                Text(
                  description ?? '',
                  style: const TextStyle(
                    color: FiscalTheme.FONT_LIGHT_PRIMARY_COLOR,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.clip,
                ),
                Text(
                  Converters.convertTransactionTypeEnum(transactionType),
                  key: ValueKey('type'),
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    color: isIncome
                        ? FiscalTheme.POSITIVE_COLOR
                        : FiscalTheme.NEGATIVE_COLOR,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.only(left: 2.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FittedBox(
                    child: Text(
                      transactionDate.toIso8601String(),
                      style: const TextStyle(),
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '₹' + amount.toStringAsFixed(2),
                    key: ValueKey('amount'),
                    style: TextStyle(
                      color: isIncome
                          ? FiscalTheme.POSITIVE_COLOR
                          : FiscalTheme.NEGATIVE_COLOR,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
