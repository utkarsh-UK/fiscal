import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';

class NavigationService {
  static const CLASS_NAME = 'NavigationService';
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateToNamed(String routeName,
      {Map<String, dynamic> arguments = const {}}) {
    FLog.info(
      text: 'Request to navigate to Route: [$routeName], arguments: [$arguments]',
      className: CLASS_NAME,
      methodName: 'navigateToNamed()',
    );
    return navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> navigateToReplacement(String routeName,
      {Map<String, dynamic> arguments = const {}}) {
    FLog.info(
      text: 'Request to navigate to Route: [$routeName], arguments: [$arguments]',
      className: CLASS_NAME,
      methodName: 'navigateToReplacement()',
    );
    return navigatorKey.currentState!
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> removeAllAndPush(String routeName,
      {Map<String, dynamic> arguments = const {}}) {
    FLog.info(
      text: 'Request to navigate to Route: [$routeName], arguments: [$arguments]',
      className: CLASS_NAME,
      methodName: 'removeAllAndPush()',
    );
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
        routeName, (route) => false,
        arguments: arguments);
  }

  Future<dynamic> resetNavigatorWithNamed(String routeName,
      {Map<String, dynamic> arguments = const {}}) {
    FLog.info(
      text: 'Request to navigate to Route: [$routeName], arguments: [$arguments]',
      className: CLASS_NAME,
      methodName: 'resetNavigatorWithNamed()',
    );
    return navigatorKey.currentState!
        .pushNamedAndRemoveUntil(routeName, (_) => false, arguments: arguments);
  }

  void navigateBack() {
    FLog.info(
      text: 'Request to pop current screen',
      className: CLASS_NAME,
      methodName: 'navigateBack()',
    );
    return navigatorKey.currentState!.pop();
  }
}
