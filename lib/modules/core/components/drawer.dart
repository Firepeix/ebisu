import 'package:ebisu/modules/core/interactor.dart';
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
        E.DrawerHeader(username: "Arthur Fernandes", email: "arthurhmf@gmail.com"),
        E.DrawerItem(
          icon: Icon(Icons.home),
          title: "Despesas",
          onTap: () {
            Navigator.pushNamed(context, '/');
          }
        ),
        E.DrawerItem(
          icon: Icon(Icons.shopping_cart),
          title:"Listas de Compra",
          onTap: () {
            Navigator.pushNamed(context, '/shopping-list');
          }
        ),
        E.DrawerItem(
            icon: Icon(Icons.book),
            title:"Livros",
            onTap: () => _interactor.initScoutBookModule()
        )
      ],
    ),
  );
}