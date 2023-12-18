import 'package:ebisu/modules/layout/core.dart';
import 'package:ebisu/modules/user/entry/component/user_context.dart';
import 'package:ebisu/shared/configuration/app_configuration.dart';
import 'package:ebisu/shared/dependency/dependency_container.dart';
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

  Route getRoute(Map<String, dynamic> arguments, AppTheme userTheme, ThemeData theme) {
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
            child: UserContext(id: userTheme, child: child, theme: theme,),
          );
        });
  }

  Widget getDrawer() {
    return DependencyManager.get<CoreInterface>().getDrawer();
  }

  @protected
  Widget scaffold(BuildContext context, {
    String title =  '',
    required body ,
    hasDrawer =  true,
    Widget? actionButton
  }) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: hasDrawer ? getDrawer() : null,
      body: body,
      floatingActionButton: actionButton,
    );
  }
}