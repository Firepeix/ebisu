import 'package:ebisu/ui_components/chronos/actions/tap.dart';
import 'package:ebisu/ui_components/chronos/colors/colors.dart';
import 'package:ebisu/ui_components/chronos/list/tile.dart';
import 'package:ebisu/ui_components/chronos/menus/simple_menu.dart';
import 'package:ebisu/ui_components/chronos/time/moment.dart';
import 'package:flutter/material.dart';

typedef BookActionCallback = void Function(String id, BookAction action);

enum BookAction {
  MARK_AS_READ,
  POSTPONE,
  ACTIVATE,
}

class BookViewModel extends StatelessWidget {
  final String id;
  final String _name;
  String get name => _name;
  final BookChapter _chapter;
  BookChapter get chapter => _chapter;
  final Moment? ignoreUntil;
  final OnTap<BookActionCallback> onTap = OnTap<BookActionCallback>();

  BookViewModel(this._name, this._chapter, {Key? key, required this.id, this.ignoreUntil}) : super(key: key);


  MenuItem<BookAction> get stateItem {
    if(ignoreUntil == null) {
      return MenuItem(BookAction.POSTPONE, Row(children: [Icon(Icons.calendar_today, color: EColor.accent,), Text("     Adiar para depois")],));

  }

    return MenuItem(BookAction.ACTIVATE, Row(children: [Icon(Icons.play_arrow, color: EColor.secondary,), Text("     Ativar")],));
  }

  @override
  Widget build(BuildContext context) => Tile(
    title: "$_name:  ",
    accent: _chapter.value,
    subtitle: ignoreUntil != null ? "Desativado até $ignoreUntil" : "Ativo",
    trailing: SimpleMenu<BookAction>(
      icon:  Icons.more_vert,
      onSelected: (action) => onTap.action?.call(id, action),
      children: [
        MenuItem(BookAction.MARK_AS_READ, Row(children: [Icon(Icons.check, color: EColor.success,), Text("     Marcar como lido")],)),
        stateItem,
      ]
    ),
  );

}

class BookChapter {
  final String _value;

  BookChapter(this._value);

  String get value => _value;
}
/*EbisuIconButton(
      icon: Icons.more_vert,
      onPressed: () {  },
    )*/