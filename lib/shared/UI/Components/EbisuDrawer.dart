import 'package:flutter/material.dart';

class EbisuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          accountName: Text("Arthur Fernandes"),
          accountEmail: Text("arthurhmf@gmail.com"),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Theme.of(context).platform == TargetPlatform.iOS  ? Colors.red: Colors.white,
            child: Text("AF", style: TextStyle(fontSize: 36.0),),
          ),
        ),
        ListTile(
          leading: Icon(Icons.home),
          title: Text("Despesas"),
          onTap: () {
            Navigator.pushNamed(context, '/');
          }
        ),
        ListTile(
          leading: Icon(Icons.shopping_cart),
          title: Text("Listas de Compra"),
          onTap: () {
            Navigator.pushNamed(context, '/shopping-list');
          }
        )
      ],
    ),
  );
}