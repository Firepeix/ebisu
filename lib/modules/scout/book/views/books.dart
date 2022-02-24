import 'package:ebisu/modules/scout/book/interactor.dart';
import 'package:ebisu/modules/scout/book/models/book.dart';
import 'package:ebisu/shared/UI/Components/Buttons.dart';
import 'package:ebisu/ui_components/chronos/bodies/body.dart';
import 'package:flutter/material.dart';

class BooksView extends StatelessWidget {
  final BookInteractorInterface _interactor;


  const BooksView(this._interactor, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(
          title: const Text("Livros"),
        ),
        floatingActionButton: ExpandableFab(
          openChild: Icon(Icons.arrow_upward),
          children: [
            ActionButton(
              tooltip: "Limpar Logs",
                icon: Icon(Icons.delete, color: Colors.white,)
            )
          ],
        ),
        drawer: _interactor.getDrawer(),
        body: Body(
          child: BookList(_interactor),
        ),
      );
}

class BookList extends StatefulWidget {
  final BookInteractorInterface _interactor;
  const BookList(this._interactor, {Key? key}) : super(key: key);

  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  List<BookViewModel> _books = [];

  @override
  void initState() {
    super.initState();
    getBooks();
  }

  void getBooks() {
    final books = widget._interactor.getBooks();
    books.forEach((element) {
      element.onTap.action = onBookTap;
      _books.add(element);
    });
    return;
    /*final books = [
      BookViewModel("Nozomanu Fushi no Boukensha", BookChapter("41"), id: "1",),
      BookViewModel("Nozomanu Fushi no Boukensha", BookChapter("44"), id: "2", ignoreUntil: Moment.now(),)
    ];
    books.forEach((element) {
      element.onTap.action = onBookTap;
      _books.add(element);
    });*/
  }

  void onBookTap(String id, BookAction action) {
    print([id, action]);
  }

  @override
  Widget build(BuildContext context) => RefreshIndicator(
      child: ListView.builder(
          itemCount: _books.length,
          itemBuilder: (BuildContext context, int index) => _books[index]
      ),
      onRefresh: () async {}
  );
}

