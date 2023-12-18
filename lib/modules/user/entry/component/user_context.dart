import 'package:ebisu/shared/configuration/app_configuration.dart';
import 'package:flutter/material.dart';

enum Skin {
  TUTU,
  WEWE
}

typedef LocalizedString = Map<Skin, String>;

class UserContext extends StatelessWidget {
  final Skin id;
  final Widget child;
  final ThemeData theme;

  const UserContext({required AppTheme id, required this.child, required this.theme, super.key}) :
        this.id = id == AppTheme.tutu ? Skin.TUTU : Skin.WEWE;

  static UserContext of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<UserContext>()!;
  }

  UserContext copyWith({required Widget child}) {
    return UserContext(id: toggle(tutu: AppTheme.tutu, wewe: AppTheme.wewe), child: child, theme: theme);
  }

  Widget show({Widget? tutu, Widget? wewe}) {
    if (id == Skin.TUTU) {
      return tutu ?? Container();
    }

    return wewe ?? Container();
  }

  T toggle<T>({required T tutu, required T wewe}) {
    if (id == Skin.TUTU) {
      return tutu;
    }

    return wewe;
  }

  String localize(LocalizedString value) {
    return value[id] ?? value[Skin.TUTU]!;
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
