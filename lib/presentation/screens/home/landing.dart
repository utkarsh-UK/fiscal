import 'package:fiscal/core/core.dart';
import 'package:fiscal/presentation/screens/home/home.dart';
import 'package:flutter/material.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  late List<Widget> _screens = [];
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();

    _screens = [
      Home(key: ValueKey('home')),
      Container(key: ValueKey('trans'), child: Text('Transactions Page')),
      Container(key: ValueKey('stats'), child: Text('Stats Page')),
      Container(key: ValueKey('accounts'), child: Text('Accounts Page')),
      Container(key: ValueKey('settings'), child: Text('Settings Page')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: _buildBottomNavBar(size),
      floatingActionButton: _pageIndex < 2
          ? FloatingActionButton(
              key: ValueKey('fab'),
              onPressed: () {},
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
          IconButton(onPressed: () => _changePage(0), icon: Icon(Icons.home)),
          IconButton(
            key: ValueKey('tran_menu'),
            onPressed: () => _changePage(1),
            icon: Icon(Icons.list),
          ),
          IconButton(
            onPressed: () => _changePage(2),
            icon: Icon(Icons.chat_rounded),
          ),
          IconButton(
            onPressed: () => _changePage(3),
            icon: Icon(Icons.house),
          ),
          IconButton(
            onPressed: () => _changePage(4),
            icon: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }

  void _changePage(int index) => setState(() => _pageIndex = index);
}