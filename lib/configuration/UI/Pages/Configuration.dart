import 'package:ebisu/card/Domain/Card.dart';
import 'package:ebisu/configuration/UI/Components/ActiveSheetConfiguration.dart';
import 'package:ebisu/configuration/UI/Components/CleanCardTypeCache.dart';
import 'package:ebisu/configuration/UI/Components/CleanCredentials.dart';
import 'package:ebisu/configuration/UI/Components/SheetIdConfiguration.dart';
import 'package:ebisu/src/Domain/Pages/AbstractPage.dart';
import 'package:flutter/material.dart';

class ConfigurationPage extends AbstractPage {
  static Route getRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ConfigurationPage(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 30),
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 0), child: ActiveSheetConfiguration(type: CardClass.DEBIT),),
          Padding(padding: EdgeInsets.only(top: 15), child: ActiveSheetConfiguration(type: CardClass.CREDIT),),
          Padding(padding: EdgeInsets.only(top: 15), child: SheetIdConfiguration(),),
          CleanCardTypeCache(),
          CleanCredentials()
        ],
      ),
    );
  }
}
