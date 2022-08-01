import 'package:ebisu/main.dart';
import 'package:ebisu/modules/core/interactor.dart';
import 'package:ebisu/pages/travel/days/travel_expense_page.dart';
import 'package:ebisu/shared/configuration/app_configuration.dart';
import 'package:ebisu/ui_components/chronos/drawer/header.dart' as E;
import 'package:flutter/material.dart';

class EbisuDrawer extends StatelessWidget {
  static final configuration = AppConfiguration();

  final CoreInteractorInterface _interactor;

  EbisuDrawer(this._interactor);

  Map<String, Widget> _createItems(BuildContext context) {
    return {
      "expenses": E.DrawerItem(
          icon: Icon(Icons.home),
          title: "Despesas",
          onTap: () {
            Navigator.pushNamed(context, '/');
          }
      ),
      "shopping": E.DrawerItem(
          icon: Icon(Icons.shopping_cart),
          title:"Listas de Compra",
          onTap: () {
            Navigator.pushNamed(context, '/shopping-list');
          }
      ),
      "books": E.DrawerItem(
          icon: Icon(Icons.book),
          title:"Livros",
          onTap: () => _interactor.initScoutBookModule()
      ),
      "travel": E.DrawerItem(
          icon: Icon(Icons.airplanemode_active),
          title:"Viagens",
          onTap: () => routeTo(context, TravelExpensePage())
      )
    };
  }

  List<Widget> _makeItems(BuildContext context) {
    final List<Widget> items = [];
    final allItems = _createItems(context);
    configuration.features.forEach((feature) {
      final item = allItems[feature.id];
      if (item != null) {
        items.add(item);
      }
    });
    return items;
  }

  @override
  Widget build(BuildContext context) => Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        E.DrawerHeader(username: configuration.user.name, email: configuration.user.email),
        ..._makeItems(context)
      ],
    ),
  );
}