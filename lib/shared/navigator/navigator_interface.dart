import 'package:ebisu/main.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class NavigatorService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

abstract class NavigatorInterface {
  late final Map<String, Function> routes;

  Route route(String name, Map<String, dynamic> arguments) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => view(name, arguments),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween = Tween(begin: begin, end: end);
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        });
  }


  Widget view(String name, Map<String, dynamic> arguments) {
    if (routes.containsKey(name)) {
      return routes[name]!(name, arguments);
    }

    return MyHomePage(title: 'Home');
  }
}
