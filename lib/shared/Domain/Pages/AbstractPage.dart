import 'package:ebisu/shared/UI/Components/EbisuDrawer.dart';
import 'package:flutter/material.dart';

abstract class AbstractPage extends StatelessWidget  {
  final Function? onChangeTo;
  AbstractPage({this.onChangeTo});
  Route getRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => this,
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

  @protected
  Widget scaffold(BuildContext context, String title, Widget body) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: EbisuDrawer(),
      body: body,
    );
  }
}