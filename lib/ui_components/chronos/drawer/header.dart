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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return UserAccountsDrawerHeader(
      accountName: Text(username),
      accountEmail: Text(email),
      currentAccountPicture: CircleAvatar(
        backgroundColor: theme.platform == TargetPlatform.iOS  ? theme.colorScheme.primary : Colors.white,
        child: Text(initials(), style: TextStyle(fontSize: 36.0, color: theme.colorScheme.primary),),
      ),
    );
  }
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