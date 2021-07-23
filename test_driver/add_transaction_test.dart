import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:intl/intl.dart';
import 'package:test/test.dart';

void main() {
  group('Add Transaction', () {
    final fab = find.byValueKey('fab');
    final income = find.byValueKey('income');
    final expense = find.byValueKey('expense');
    final emptyRecentTransactions = find.byValueKey('empty_trans');
    final addTransactionScreen = find.text('Add Transaction');
    final titleInputField = find.byValueKey('trans_title');
    final amountInputField = find.byValueKey('trans_amount');
    final catDropdownInputField = find.byValueKey('categories_dropdown');
    final dateInputField = find.byValueKey('date_picker');
    final dateValue = find.text('10');
    final okButton = find.text('OK');
    final descInputField = find.byValueKey('description');
    final saveButton = find.byValueKey('save');
    final progressIndicator = find.byValueKey('progress');
    final closeButton = find.byValueKey('close');
    final recentTransTitle = find.text('First Transaction');
    final recentTransType = find.byValueKey('type');

    late FlutterDriver driver;

    setUpAll(() async {
      final String adbPath = 'C:/Users/utkar/AppData/Local/Android/Sdk/platform-tools/adb.exe';

      await Process.run(adbPath, [
        'shell',
        'pm',
        'grant',
        'integration.utkarshkore.fiscal',
        'android.permission.READ_EXTERNAL_STORAGE',
      ]);
      await Process.run(adbPath, [
        'shell',
        'pm',
        'grant',
        'integration.utkarshkore.fiscal',
        'android.permission.WRITE_EXTERNAL_STORAGE',
      ]);

      driver = await FlutterDriver.connect();
      await driver.waitUntilFirstFrameRasterized();
    });

    tearDownAll(() async {
      driver.close();
    });

    test('Transaction summary and recent transactions are empty', () async {
      //assert
      await driver.waitFor(find.text('INR   0.00'));
      expect(await driver.getText(income), '0.00');
      expect(await driver.getText(expense), '0.00');
      expect(await driver.getText(emptyRecentTransactions), 'No Transactions Yet');
    });

    test('Open add transaction screen and ensure form is visible', () async {
      //act
      await driver.tap(fab);
      //assert
      await driver.waitFor(addTransactionScreen);
    });

    test('Fill transaction details and save', () async {
      await driver.runUnsynchronized(() async {
        //arrange
        final currentMonth = DateFormat('MMMM').format(DateTime.now());
        //act
        // enter title
        await driver.tap(titleInputField);
        await driver.enterText('First Transaction');

        //enter amount
        await driver.tap(amountInputField);
        await driver.enterText('125.50');

        //select category
        await driver.tap(catDropdownInputField);
        await driver.tap(find.text('Food'));

        //enter date
        await driver.tap(dateInputField);
        await driver.tap(dateValue);
        await driver.tap(okButton);
        await driver.tap(okButton);

        //enter description
        await driver.tap(descInputField);
        await driver.enterText('This is description');
        await driver.scroll(find.byValueKey('scroller'), 0, -300, const Duration(milliseconds: 800));

        //click save
        await driver.tap(saveButton);

        //assert
        await driver.waitFor(progressIndicator);
        await driver.waitFor(saveButton);
        await driver.scroll(find.byValueKey('scroller'), 0, 300, const Duration(milliseconds: 800));

        //click close button
        await driver.tap(closeButton);

        //verify transaction is added
        await driver.waitFor(find.text('INR   -125.50'));
        expect(await driver.getText(income), '0.00');
        expect(await driver.getText(expense), '125.50');
        expect(await driver.getText(recentTransTitle), 'First Transaction');
        expect(await driver.getText(recentTransType), 'Expense');
        expect(await driver.getText(find.text('$currentMonth 10')), '$currentMonth 10');
      });
    });
  });
}
