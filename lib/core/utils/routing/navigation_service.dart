import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateToNamed(String routeName,
      {Map<String, dynamic> arguments = const {}}) {
    return navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> navigateToReplacement(String routeName,
      {Map<String, dynamic> arguments = const {}}) {
    return navigatorKey.currentState!
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> removeAllAndPush(String routeName,
      {Map<String, dynamic> arguments = const {}}) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
        routeName, (route) => false,
        arguments: arguments);
  }

  Future<dynamic> resetNavigatorWithNamed(String routeName,
      {Map<String, dynamic> arguments = const {}}) {
    return navigatorKey.currentState!
        .pushNamedAndRemoveUntil(routeName, (_) => false, arguments: arguments);
  }

  void navigateBack() {
    return navigatorKey.currentState!.pop();
  }
}
