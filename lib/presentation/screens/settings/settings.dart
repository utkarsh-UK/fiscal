import 'package:fiscal/core/core.dart';
import 'package:fiscal/di/locator.dart';
import 'package:fiscal/presentation/widgets/home/screen_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ScreenTitle(key: ValueKey('settings_title'), title: 'Settings'),
                const SizedBox(height: 10.0),
                ListView(
                  key: ValueKey('settings_list'),
                  shrinkWrap: true,
                  children: settingsOptions
                      .map((setting) => GestureDetector(
                            onTap: () => locator.get<NavigationService>().navigateToNamed(setting['route']!),
                            child: Container(
                              decoration: BoxDecoration(color: Color(0xFFF2F2F2), borderRadius: BorderRadius.circular(6.0)),
                              margin: const EdgeInsets.only(bottom: 10.0),
                              child: ListTile(
                                isThreeLine: false,
                                dense: true,
                                title: Text(
                                  setting['title']!,
                                  style: FiscalTheme.inputText.copyWith(
                                    fontSize: 20.0,
                                  ),
                                ),
                                leading: SvgPicture.asset(
                                  setting['icon']!,
                                  width: 25.0,
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
