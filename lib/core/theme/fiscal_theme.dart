import 'package:flutter/material.dart';

class FiscalTheme {
  // colors
  static const Color PRIMARY_COLOR = Color(0xFF72147e);
  static const Color SECONDARY_COLOR = Color(0xFFf21170);
  static const Color ACCENT_COLOR = Color(0xFFfa9905);

  static const Color FONT_DARK_PRIMARY_COLOR = Color(0xFF221f3b);
  static const Color FONT_LIGHT_PRIMARY_COLOR = Color(0xFF57335d);
  static const Color FONT_DARK_SECONDARY_COLOR = Color(0xFFffffff);
  static const Color FONT_LIGHT_SECONDARY_COLOR = Color(0xFFcbc9c9);

  static const Color CARD_COLOR = Color(0xFFebebeb);
  static const Color BACKGROUND_COLOR = Color(0xFFfafafa);
  static const Color MENU_PRIMARY_COLOR = Color(0xFF221f3b);
  static const Color MENU_SECONDARY_COLOR = Color(0xFFB05ABA);

  static const Color BLUE_COLOR = Color(0xFFfafafa);
  static const Color BROWN_COLOR = Color(0xFFfafafa);
  static const Color GREEN_COLOR = Color(0xFFfafafa);
  static const Color OTHER_COLOR = Color(0xFFfafafa);

  static const Color POSITIVE_COLOR = Color(0xFF29bb89);
  static const Color NEGATIVE_COLOR = Color(0xFFfb3640);

  static const Color TEXT_INPUT_BORDER_COLOR = Color(0xFFBDBDBD);
  static const Color TEXT_INPUT_BACKGROUND_COLOR = Color(0xFFF1F1F1);

  // font family
  static const String PRIMARY_FONT_PATUA = 'Patua One';
  static const String SECONDARY_FONT_SIGNIKA = 'Signika';

  // text theme
  static TextStyle screenTitleText = TextStyle(
    color: FiscalTheme.FONT_DARK_PRIMARY_COLOR,
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
  );
  static TextStyle welcomeText = TextStyle(color: Color(0xFF524E79), fontSize: 20.0, fontWeight: FontWeight.w600);
  static TextStyle sectionHeadingText = TextStyle(
    color: FiscalTheme.FONT_DARK_PRIMARY_COLOR,
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
  );
  static TextStyle screenActionTitleText = TextStyle(
    color: FiscalTheme.PRIMARY_COLOR,
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
  );
  static TextStyle inputText = TextStyle(
    color: FiscalTheme.FONT_DARK_PRIMARY_COLOR,
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  );
  static TextStyle smallButtonText = TextStyle(
    color: FiscalTheme.ACCENT_COLOR,
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
  );
  static TextStyle bodyWhiteText = TextStyle(
    fontSize: 18.0,
    color: FiscalTheme.FONT_LIGHT_SECONDARY_COLOR,
    fontFamily: FiscalTheme.SECONDARY_FONT_SIGNIKA,
    fontWeight: FontWeight.w700,
  );
  static TextStyle titleText = TextStyle(
    color: FiscalTheme.FONT_DARK_PRIMARY_COLOR,
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
  );
  static TextStyle subTitleText = TextStyle(
    color: FiscalTheme.FONT_LIGHT_PRIMARY_COLOR,
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
  );
  static TextStyle subTitle2Text = TextStyle(
    color: FiscalTheme.POSITIVE_COLOR,
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
  );
}
