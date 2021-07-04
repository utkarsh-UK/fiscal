import 'package:fiscal/core/core.dart';
import 'package:fiscal/core/utils/static/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: size.width * 0.2,
            child: Row(
              children: [
                Container(
                  height: 60.0,
                  width: 5.0,
                  decoration: BoxDecoration(
                    color: FiscalTheme.SECONDARY_COLOR,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
                const SizedBox(width: 8.0),
                Container(
                  key: ValueKey('icon'),
                  width: 40.0,
                  height: 40.0,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFFAFAFA),
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(color: Colors.grey[400]!, blurRadius: 6.0),
                    ],
                  ),
                  child: SvgPicture.asset(
                    FiscalAssets.INVESTMENT_ICON,
                    width: 10.0,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: size.width * 0.43,
            padding: const EdgeInsets.only(right: 4.0),
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
                const SizedBox(height: 4.0),
                Text(
                  description ?? 'N/A',
                  style: const TextStyle(
                    color: FiscalTheme.FONT_LIGHT_PRIMARY_COLOR,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.clip,
                  softWrap: false,
                ),
                const SizedBox(height: 4.0),
                Text(
                  Converters.convertTransactionTypeEnum(transactionType)
                      .titleCase,
                  key: ValueKey('type'),
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    color: isIncome
                        ? FiscalTheme.POSITIVE_COLOR
                        : FiscalTheme.NEGATIVE_COLOR,
                    fontSize: 14.0,
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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    DateFormat.MMMMd().format(transactionDate),
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
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
