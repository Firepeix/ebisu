import 'package:ebisu/shared/UI/Components/EbisuDrawer.dart';
import 'package:flutter/material.dart';

abstract class AbstractPage extends StatelessWidget  {
  final ScrollController scroll = ScrollController();
  final Function? onChangeTo;
  final Map<String, dynamic> arguments = {};
  AbstractPage({this.onChangeTo});

  void _parseArguments (Map<String, dynamic> arguments) {
    arguments.forEach((String key, dynamic value) {
      this.arguments[key] = value;
    });
  }

  @protected
  void dismissKeyboard (BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  Route getRoute(Map<String, dynamic> arguments) {
    _parseArguments(arguments);
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
  Widget scaffold(BuildContext context, {
    String title: '',
    required body ,
    hasDrawer: true,
    Widget? actionButton
  }) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: hasDrawer ? EbisuDrawer() : null,
      body: body,
      floatingActionButton: actionButton,
    );
  }
}