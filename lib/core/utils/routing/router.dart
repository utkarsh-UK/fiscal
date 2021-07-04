import 'package:fiscal/core/utils/routing/route_names.dart';
import 'package:fiscal/presentation/screens/home/add_new_transaction.dart';
import 'package:fiscal/presentation/screens/home/landing.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return _getPageRoute(Landing(), settings);
    case ADD_NEW_TRANSACTION:
      return _getPageRoute(AddNewTransaction(), settings);
    default:
      return _getPageRoute(Landing(), settings);
  }
}

PageRoute _getPageRoute(Widget child, RouteSettings settings) {
  return _FadeRoute(child: child, routeName: settings.name!);
}

class _FadeRoute extends PageRouteBuilder {
  final Widget child;
  final String routeName;

  _FadeRoute({required this.child, required this.routeName})
      : super(
            settings: RouteSettings(name: routeName),
            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => child,
            transitionsBuilder:
                (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) =>

                    FadeTransition(opacity: animation, child: child),
                    // ScaleTransition(scale: animation, child: child),
                    // Align(
                    //   child: SizeTransition(
                    //     sizeFactor: animation,
                    //     child: child,
                    //     axisAlignment: 0.0,
                    //   ),
                    // )
// SlideTransition(
//     position: Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0)).animate(animation), child: child)
            );
}
