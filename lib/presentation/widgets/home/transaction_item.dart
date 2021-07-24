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
  final String iconName;
  final Color iconColor;

  const TransactionItem({
    Key? key,
    required this.title,
    required this.description,
    required this.transactionType,
    required this.transactionDate,
    required this.amount,
    this.iconName = 'others',
    this.iconColor = const Color(0xFF000000),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final containerSize = size.width - 16.0;
    final bool isIncome = transactionType == TransactionType.INCOME;
    String desc = '';

    if (description == null)
      desc = '';
    else
      desc = description!.isNotEmpty ? description! : 'N/A';

    return Container(
      width: containerSize,
      decoration: BoxDecoration(
        color: Color(0xFFFAFAFA),
        border: Border.all(color: Color(0xFFBABABA)),
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
                    color: iconColor,
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
                  child: SvgPicture.asset('${FiscalAssets.ICONS_PATH}$iconName.svg', width: 10.0),
                ),
              ],
            ),
          ),
          Container(
            width: containerSize * 0.43,
            padding: const EdgeInsets.only(right: 4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  key: ValueKey('title'),
                  style: FiscalTheme.titleText,
                  overflow: TextOverflow.clip,
                  softWrap: false,
                ),
                const SizedBox(height: 4.0),
                Text(
                  desc,
                  style: FiscalTheme.subTitleText,
                  overflow: TextOverflow.clip,
                  softWrap: false,
                ),
                const SizedBox(height: 4.0),
                Text(
                  Converters.convertTransactionTypeEnum(transactionType).titleCase,
                  key: ValueKey('type'),
                  overflow: TextOverflow.clip,
                  style: FiscalTheme.subTitle2Text.copyWith(
                    color: isIncome ? FiscalTheme.POSITIVE_COLOR : FiscalTheme.NEGATIVE_COLOR,
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
                    style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '₹' + amount.toStringAsFixed(2),
                    key: ValueKey('amount'),
                    style: FiscalTheme.subTitle2Text.copyWith(
                      color: isIncome ? FiscalTheme.POSITIVE_COLOR : FiscalTheme.NEGATIVE_COLOR,
                      fontSize: 18.0,
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
