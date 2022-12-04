import 'package:ebisu/modules/scout/book/models/book.dart';
import 'package:ebisu/shared/state/async_component.dart';
import 'package:ebisu/ui_components/chronos/list/tile.dart';
import 'package:flutter/material.dart';
import 'package:ebisu/ui_components/chronos/labels/label.dart';

typedef BookActionCallback = Future<BookModel> Function(BookModel book);

class BookListItem extends StatefulWidget {
  final BookModel _book;
  final BookActionCallback? onTap;

  BookListItem(this._book, {Key? key, this.onTap}) : super(key: key);

  @override
  _BookListItemState createState() => _BookListItemState(_book);
}

class _BookListItemState extends State<BookListItem> with AsyncComponent<BookListItem> {
  BookModel book;

  _BookListItemState(this.book);

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BookListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    book = widget._book;
  }

  @override
  Widget build(BuildContext context) {
    return Tile(
      titleText: "${book.name}:  ",
      subtitleText: book.isIgnored ? "Desativado" : "Ativo",
      trailing: Label.main(
        text: book.chapter.value,
        size: 18,
      ),
      onTap: () async {
        final _book = await widget.onTap?.call(book);
        if (_book != null) {
          updateState(() {
            book = _book;
          });
        }
      },
    );
  }
}
