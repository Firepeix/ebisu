import 'package:ebisu/ui_components/chronos/actions/tap.dart';
import 'package:ebisu/ui_components/chronos/colors/colors.dart';
import 'package:ebisu/ui_components/chronos/list/tile.dart';
import 'package:ebisu/ui_components/chronos/menus/simple_menu.dart';
import 'package:ebisu/ui_components/chronos/time/moment.dart';
import 'package:flutter/material.dart';
import 'package:ebisu/ui_components/chronos/labels/label.dart';

typedef BookActionCallback = void Function(BookViewModel book);

enum BookAction {
  MARK_AS_READ,
  POSTPONE,
  ACTIVATE,
}

class BookViewModel extends StatefulWidget {
  final String id;
  final String _name;
  String get name => _name;
  final BookChapter _chapter;
  BookChapter get chapter => _chapter;
  final OnTap<BookActionCallback> onTap = OnTap<BookActionCallback>();
  late final Moment? _originalIgnoredUntil;

  String get statusName  => ignoreUntil != null ? "Desativado" : "Ativo";
  bool get isIgnored  => ignoreUntil != null;


  _BookState? get _state => (key as GlobalKey<_BookState>).currentState;

  Moment? get ignoreUntil {
    if(_state != null) {
      return _state!.ignoredUntil;
    }
    return _originalIgnoredUntil;
  }

  set ignoreUntil(Moment? value) {
    _state?.ignoredUntil = value;
  }

  void save() => _state?.save();

  BookViewModel(this._name, this._chapter, {Key? key, required this.id, Moment? ignoreUntil}) : super(key: key ?? GlobalKey<_BookState>()) {
    _originalIgnoredUntil = ignoreUntil;
  }

  @override
  _BookState createState() => _BookState(this._originalIgnoredUntil);
}

class _BookState extends State<BookViewModel> {
  Moment? ignoredUntil;

  _BookState(this.ignoredUntil);

  void save() => setState(() {

  });

  @override
  Widget build(BuildContext context) {
    return Tile(
      titleText: "${widget._name}:  ",
      subtitleText: ignoredUntil != null ? "Desativado" : "Ativo",
      trailing: Label.main(text: widget._chapter.value, size: 18,),
      onTap: () {
        widget.onTap.action?.call(widget);
      },
    );
  }
}

class BookChapter {
  String _value;

  BookChapter(this._value);

  String get value => _value;

  void increment() {
    if(value.contains('.')) {
      _value = (double.parse(_value) + 0.1).toString();
      return;
    }

    _value = (int.parse(_value) + 1).toString();
  }
}

