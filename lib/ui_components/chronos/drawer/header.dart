import 'package:flutter/material.dart';

class DrawerHeader extends StatelessWidget{
  final String username;
  final String email;

  const DrawerHeader({Key? key, required this.username, required this.email}) : super(key: key);

  String initials() {
    var initial = "";
    final names = username.split(" ");
    initial += names.first.split("").first;
    if(names.length > 1) {
      initial += names.last.split("").first;
    }

    return initial.toUpperCase();
  }

  @override
  Widget build(BuildContext context) => UserAccountsDrawerHeader(
    accountName: Text(username),
    accountEmail: Text(email),
    currentAccountPicture: CircleAvatar(
      backgroundColor: Theme.of(context).platform == TargetPlatform.iOS  ? Colors.red: Colors.white,
      child: Text(initials(), style: const TextStyle(fontSize: 36.0),),
    ),
  );
}

class DrawerItem extends StatelessWidget {
  final String title;
  final Icon icon;
  final GestureTapCallback? onTap;

  const DrawerItem({Key? key, required this.title, required this.icon, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
      leading: icon,
      title: Text(title),
      onTap: onTap
  );
}