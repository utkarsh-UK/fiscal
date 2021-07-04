import 'package:fiscal/core/core.dart';
import 'package:fiscal/presentation/widgets/home/background_painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TransactionsSummary extends StatefulWidget {
  const TransactionsSummary({Key? key}) : super(key: key);

  @override
  _TransactionsSummaryState createState() => _TransactionsSummaryState();
}

class _TransactionsSummaryState extends State<TransactionsSummary> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final containerWidth = size.width - 16;
    final containerHeight = size.height * 0.3;

    return ClipRRect(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0)),
      child: CustomPaint(
        foregroundPainter: BackgroundPainter(),
        willChange: false,
        isComplex: false,
        child: Container(
          width: containerWidth,
          height: containerHeight,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: FiscalTheme.PRIMARY_COLOR,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Balance', style: FiscalTheme.bodyWhiteText),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'INR   ', style: FiscalTheme.bodyWhiteText),
                    TextSpan(
                      text: '5,300.00',
                      style: FiscalTheme.bodyWhiteText.copyWith(fontSize: containerWidth * 0.12),
                    ),
                  ],
                ),
                key: ValueKey('total_balance'),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
              _buildSummarySplitWidget(containerWidth, containerHeight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummarySplitWidget(double containerWidth, double containerHeight) {
    return Container(
      width: containerWidth * 0.7,
      height: containerHeight * 0.3,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(color: Color(0xFF680E74), borderRadius: BorderRadius.circular(14.0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                style: ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                onPressed: null,
                icon: SvgPicture.asset(FiscalAssets.INCOME_ICON),
                label: Text(
                  'Income',
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: FiscalTheme.FONT_LIGHT_SECONDARY_COLOR,
                    fontFamily: FiscalTheme.SECONDARY_FONT_SIGNIKA,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  '3,300.00',
                  key: ValueKey('income'),
                  style: FiscalTheme.bodyWhiteText.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                  style: ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  onPressed: null,
                  icon: SvgPicture.asset(FiscalAssets.EXPENSE_ICON),
                  label: Text(
                    'Expense',
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: FiscalTheme.FONT_LIGHT_SECONDARY_COLOR,
                      fontFamily: FiscalTheme.SECONDARY_FONT_SIGNIKA,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    '1,500.00',
                    key: ValueKey('expense'),
                    style: FiscalTheme.bodyWhiteText.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
