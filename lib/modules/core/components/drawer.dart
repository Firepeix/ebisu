import 'package:ebisu/main.dart';
import 'package:ebisu/modules/core/interactor.dart';
import 'package:ebisu/pages/travel/days/travel_expense_page.dart';
import 'package:ebisu/ui_components/chronos/drawer/header.dart' as E;
import 'package:flutter/material.dart';

class EbisuDrawer extends StatelessWidget {

  final CoreInteractorInterface _interactor;

  EbisuDrawer(this._interactor);

  @override
  Widget build(BuildContext context) => Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        E.DrawerHeader(username: "Wendy Artiaga", email: "wendy.artiaga@gmail.com"),
        E.DrawerItem(
            icon: Icon(Icons.airplanemode_active),
            title:"Viagens",
            onTap: () => routeTo(context, TravelExpensePage())
        )
      ],
    ),
  );
}