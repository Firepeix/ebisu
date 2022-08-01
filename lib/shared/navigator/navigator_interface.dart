import 'package:ebisu/main.dart';
import 'package:ebisu/shared/utils/matcher.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

enum IntoViewAnimation {
  pop,
  slide
}

@lazySingleton
class NavigatorService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void routeTo(BuildContext context, Widget view, { IntoViewAnimation? animation }) {
    Navigator.push(context, NavigatorInterface.staticRoute(view, intoViewAnimation: animation));
  }
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

  static Route staticRoute(Widget route, { IntoViewAnimation? intoViewAnimation }) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => route,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return Matcher.matchWhen(intoViewAnimation, {
            IntoViewAnimation.slide: slide(child, animation),
            IntoViewAnimation.pop: pop(child, animation)
          },
          base: slide(child, animation));
        });
  }

  static slide(Widget child, Animation<double> animation) {
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
  }

  static pop(Widget child, Animation<double> animation) {
    const curve = Curves.ease;

    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: curve,
    );

    return ScaleTransition(
      scale: curvedAnimation,
      child: child,
    );
  }


  Widget view(String name, Map<String, dynamic> arguments) {
    if (routes.containsKey(name)) {
      return routes[name]!(name, arguments);
    }

    return MyHomePage(title: 'Home');
  }
}
