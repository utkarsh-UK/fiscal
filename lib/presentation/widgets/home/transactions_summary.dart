import 'package:fiscal/core/core.dart';
import 'package:fiscal/presentation/provider/transaction_provider.dart';
import 'package:fiscal/presentation/widgets/home/background_painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class TransactionsSummary extends StatefulWidget {
  const TransactionsSummary({Key? key}) : super(key: key);

  @override
  _TransactionsSummaryState createState() => _TransactionsSummaryState();
}

class _TransactionsSummaryState extends State<TransactionsSummary> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      context.read<TransactionProvider>().getDailySummary();
    });
  }

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
          child: Consumer<TransactionProvider>(
            builder: (context, provider, child) {
              if (provider.status == TransactionStatus.REFRESHING)
                return Center(child: CircularProgressIndicator(key: ValueKey('progress')));
              else if (provider.status == TransactionStatus.ERROR)
                return ErrorWidget(provider.error);
              // else if (provider.status == TransactionStatus.COMPLETED)
              //   return _onAddComplete(child!);
              else {
                double expenseAmount = double.parse('${provider.providerData.summary['EXPENSE'] ?? 0.0}');
                double incomeAmount = double.parse('${provider.providerData.summary['INCOME'] ?? 0.0}');
                double totalBalance = incomeAmount - expenseAmount;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Balance', style: FiscalTheme.bodyWhiteText),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: 'INR   ', style: FiscalTheme.bodyWhiteText),
                          TextSpan(
                            text: totalBalance.toStringAsFixed(2),
                            style: FiscalTheme.bodyWhiteText.copyWith(fontSize: containerWidth * 0.12),
                          ),
                        ],
                      ),
                      key: ValueKey('total_balance'),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                    _buildSummarySplitWidget(containerWidth, containerHeight, incomeAmount, expenseAmount),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSummarySplitWidget(double containerWidth, double containerHeight, double income, double expense) {
    return Container(
      width: containerWidth * 0.7,
      height: containerHeight * 0.3,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(color: Color(0xFF680E74), borderRadius: BorderRadius.circular(14.0)),
      alignment: Alignment.center,
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
                  income.toStringAsFixed(2),
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
                    expense.toStringAsFixed(2),
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
