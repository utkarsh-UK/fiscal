import 'package:f_logs/model/flog/flog.dart';
import 'package:fiscal/core/core.dart';
import 'package:fiscal/di/locator.dart';
import 'package:fiscal/presentation/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  static const String CLASS_NAME = 'Landing';

  late List<Widget> _screens = [];
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();

    requestPermission(Permission.storage);

    _screens = [
      Home(key: ValueKey('home'), onSeeAllClicked: (int index) => _changePage(index)),
      Container(key: ValueKey('trans'), child: Text('Transactions Page')),
      Container(key: ValueKey('stats'), child: Text('Stats Page')),
      Container(key: ValueKey('accounts'), child: Text('Accounts Page')),
      Container(key: ValueKey('settings'), child: Text('Settings Page')),
    ];

    FLog.info(
      text: 'Exit: Request Permissions and initialized ${_screens.length} screens',
      className: CLASS_NAME,
      methodName: 'initState()',
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: _buildBottomNavBar(size),
      floatingActionButton: _pageIndex < 2
          ? FloatingActionButton(
              key: ValueKey('fab'),
              onPressed: () => locator.get<NavigationService>().navigateToNamed(ADD_NEW_TRANSACTION),
              backgroundColor: FiscalTheme.SECONDARY_COLOR,
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 30.0,
              ),
            )
          : SizedBox.shrink(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(child: _screens[_pageIndex]),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(Size size) {
    return Container(
      key: ValueKey('bottom_nav_bar'),
      width: size.width * 0.9,
      height: size.height * 0.07,
      margin: const EdgeInsets.only(bottom: 12.0, left: 12.0, right: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10.0,
            color: Colors.black45,
            offset: Offset(1.0, 1.5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () => _changePage(0),
            icon: SvgPicture.asset(
              FiscalAssets.MENU_HOME_ICON,
              color: _pageIndex == 0 ? FiscalTheme.MENU_PRIMARY_COLOR : FiscalTheme.MENU_SECONDARY_COLOR,
            ),
          ),
          IconButton(
            key: ValueKey('tran_menu'),
            onPressed: () => _changePage(1),
            icon: SvgPicture.asset(
              FiscalAssets.MENU_TRANSACTION_ICON,
              color: _pageIndex == 1 ? FiscalTheme.MENU_PRIMARY_COLOR : FiscalTheme.MENU_SECONDARY_COLOR,
            ),
          ),
          IconButton(
            onPressed: () => _changePage(2),
            icon: SvgPicture.asset(
              FiscalAssets.MENU_STATS_ICON,
              color: _pageIndex == 2 ? FiscalTheme.MENU_PRIMARY_COLOR : FiscalTheme.MENU_SECONDARY_COLOR,
            ),
          ),
          IconButton(
            onPressed: () => _changePage(3),
            icon: SvgPicture.asset(
              FiscalAssets.MENU_ACCOUNT_ICON,
              color: _pageIndex == 3 ? FiscalTheme.MENU_PRIMARY_COLOR : FiscalTheme.MENU_SECONDARY_COLOR,
            ),
          ),
          IconButton(
            onPressed: () => _changePage(4),
            icon: SvgPicture.asset(
              FiscalAssets.MENU_SETTINGS_ICON,
              color: _pageIndex == 4 ? FiscalTheme.MENU_PRIMARY_COLOR : FiscalTheme.MENU_SECONDARY_COLOR,
            ),
          ),
        ],
      ),
    );
  }

  void _changePage(int index) => setState(() => _pageIndex = index);

  Future<void> requestPermission(Permission permission) => permission.request();
}
