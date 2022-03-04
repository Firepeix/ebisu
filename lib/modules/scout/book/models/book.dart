import 'package:ebisu/ui_components/chronos/actions/tap.dart';
import 'package:ebisu/ui_components/chronos/colors/colors.dart';
import 'package:ebisu/ui_components/chronos/list/tile.dart';
import 'package:ebisu/ui_components/chronos/menus/simple_menu.dart';
import 'package:ebisu/ui_components/chronos/time/moment.dart';
import 'package:flutter/material.dart';

typedef BookActionCallback = void Function(BookViewModel id, BookAction action);

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
  final _BookStatus _status = _BookStatus();
  final OnTap<BookActionCallback> onTap = OnTap<BookActionCallback>();

  Moment? get ignoreUntil => _status.ignoredUntil;

  set ignoreUntil(Moment? value) {
    _status.ignoredUntil = value;
  }

  BookViewModel(this._name, this._chapter, {Key? key, required this.id, Moment? ignoreUntil}) : super(key: key) {
    _status.ignoredUntil = ignoreUntil;
  }


  MenuItem<BookAction> get stateItem {
    if(_status.ignoredUntil == null) {
      return MenuItem(BookAction.POSTPONE, Row(children: [Icon(Icons.calendar_today, color: EColor.accent,), Text("     Adiar para depois")],));

  }

    return MenuItem(BookAction.ACTIVATE, Row(children: [Icon(Icons.play_arrow, color: EColor.secondary,), Text("     Ativar")],));
  }

  @override
  Widget build(BuildContext context) => Tile(
    title: "$_name:  ",
    accent: _chapter.value,
    subtitle: _status.ignoredUntil != null ? "Desativado até ${_status.ignoredUntil}" : "Ativo",
    trailing: SimpleMenu<BookAction>(
      icon:  Icons.more_vert,
      onSelected: (action) => onTap.action?.call(this, action),
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

class _BookStatus {
  Moment? ignoredUntil;
}