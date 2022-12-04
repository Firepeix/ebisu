import 'package:ebisu/modules/scout/book/components/book_list_item.dart';
import 'package:ebisu/modules/scout/book/components/book_list_item_skeleton.dart';
import 'package:ebisu/modules/scout/book/interactor.dart';
import 'package:ebisu/modules/scout/book/models/book.dart';
import 'package:ebisu/shared/UI/Components/Buttons.dart';
import 'package:ebisu/shared/state/async_component.dart';
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
      )),
      child: BookList(_interactor),
    );
  }
}

class BookList extends StatefulWidget {
  final BookInteractorInterface _interactor;
  const BookList(this._interactor, {Key? key}) : super(key: key);

  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> with AsyncComponent<BookList> {
  List<BookModel> books = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    widget._interactor.getBooks().then((value) {
      updateState(() {
        isLoading = false;
        books = value;
      });
    });
  }

  Future<BookModel> onBookTap(BookModel model, int index) async {
    final _book = await widget._interactor.onBookTap(model);
    books[index] = _book;
    return _book;
  }

  ListView _bookList(BuildContext context) {
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (BuildContext context, int index) {
        return BookListItem(
          books[index],
          onTap: (model) => onBookTap(model, index),
        );
    });
  }

  ListView _skeletonList() {
    return ListView.builder(
      itemCount: 12,
      itemBuilder: (_, _index) => BookListItemSkeleton());
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: isLoading ? _skeletonList() : _bookList(context),
      onRefresh: () async {
        final value = await widget._interactor.getBooks();
        updateState(() {
          books = value;
      });
    });
  }
}
