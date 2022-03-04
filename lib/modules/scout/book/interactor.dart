import 'package:ebisu/modules/scout/book/models/book.dart';
import 'package:ebisu/modules/scout/book/presenter.dart';
import 'package:ebisu/modules/scout/book/services/repository.dart';
import 'package:ebisu/modules/scout/book/services/service.dart';
import 'package:ebisu/modules/scout/book/views/books.dart';
import 'package:ebisu/shared/Domain/Services/ExpcetionHandlerService.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

abstract class BookInteractorInterface {
  void init();
  Widget getDrawer();
  void onLoad(BookListState state, { VoidCallback? onDone });
  Future<void> onRefresh(BookListState state);
}

@Injectable(as: BookInteractorInterface)
class BookInteractor implements BookInteractorInterface {
  final BookServiceInterface _service;
  final BookRepositoryInterface _repository;
  final ExceptionHandlerServiceInterface _exceptionHandler;

  BookInteractor(this._service, this._repository, this._exceptionHandler);

  final _presenter = BookPresenter();

  @override
  void init() => _presenter.init();

  @override
  Widget getDrawer() => _service.getDrawer();

  Future<List<BookViewModel>> getBooks({bool cacheLess: false}) async {
    final books = await _exceptionHandler.wrapAsync(() async => await _repository.getBooks(true, cacheLess: cacheLess));
    return Future.value(books);
  }

  @override
  void onLoad(BookListState state, { VoidCallback? onDone }) async {
    _presenter.setBooks(state,  await getBooks(), onBookTap: onBookTap);
    onDone?.call();
  }

  @override
  Future<void> onRefresh(BookListState state) async {
    _presenter.setBooks(state,  await getBooks(cacheLess: true), onBookTap: onBookTap);
  }

  void onBookTap(BookViewModel book, BookAction action) async{
    print([book, action]);
  }

  Future<void> activateBook(String id) async {
    //await _exceptionHandler.wrapAsync(() async => await _repository.getBooks(true, cacheLess: cacheLess));

  }
}