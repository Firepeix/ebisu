import 'package:ebisu/modules/scout/book/interactor.dart';
import 'package:ebisu/modules/scout/book/models/book.dart';
import 'package:ebisu/shared/UI/Components/Buttons.dart';
import 'package:ebisu/ui_components/chronos/bodies/body.dart';
import 'package:ebisu/ui_components/chronos/buttons/float_action_button.dart';
import 'package:ebisu/ui_components/chronos/layout/view_body.dart';
import 'package:flutter/material.dart';

class BooksView extends StatelessWidget {
  final BookInteractorInterface _interactor;
  const BooksView(this._interactor, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewBody(
      title: "Livros",
      fab: CFloatActionButton(
        button: ExpandableFab(
          openChild: Icon(Icons.arrow_upward),
          children: [
            ActionButton(
              tooltip: "Limpar Logs",
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: () => _interactor.onCleanLogsTap(),
            )
          ],
        )
      ),
      child: BookList(_interactor),
    );
  }
}

class BookList extends StatefulWidget {
  final BookInteractorInterface _interactor;
  const BookList(this._interactor, {Key? key}) : super(key: key);

  @override
  BookListState createState() => BookListState();
}

class BookListState extends State<BookList> {
  List<BookViewModel> books = [];

  @override
  void initState() {
    super.initState();
    widget._interactor.onLoad(this, onDone: () {
      setState(() => null);
    });
  }

  @override
  Widget build(BuildContext context) => RefreshIndicator(
      child: ListView.builder(
          itemCount: books.length,
          itemBuilder: (BuildContext context, int index) => books[index]),
      onRefresh: () async {
        await widget._interactor.onRefresh(this);
        setState(() => {});
      });
}
