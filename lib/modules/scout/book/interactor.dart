import 'package:ebisu/modules/scout/book/models/book.dart';
import 'package:ebisu/modules/scout/book/presenter.dart';
import 'package:ebisu/modules/scout/book/services/repository.dart';
import 'package:ebisu/modules/scout/book/services/service.dart';
import 'package:ebisu/modules/scout/book/views/books.dart';
import 'package:ebisu/shared/Domain/Services/ExpcetionHandlerService.dart';
import 'package:ebisu/shared/Domain/Services/LoadingHandlerService.dart';
import 'package:ebisu/shared/utils/matcher.dart';
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

  void onBookTap(BookViewModel book, BookAction action) async {
    Matcher.when(action).matchAsync({
      BookAction.ACTIVATE: () async => await _activateBook(book),
      BookAction.MARK_AS_READ: () async => await _readChapter(book),
      BookAction.POSTPONE: () async => await _postpone(book)
    });
  }

  Future<void> _activateBook(BookViewModel book) async {
    LoadingHandlerService.displayLoading();
    _service.activate(book);
    await _exceptionHandler.wrapAsync(() async => await _repository.expedite(book, earlyReturn: true));
    _presenter.update(book);
    LoadingHandlerService.displaySuccess();
  }

  Future<void> _readChapter(BookViewModel book) async {
    LoadingHandlerService.displayLoading();
    _service.readChapter(book);
    await _exceptionHandler.wrapAsync(() async => await _repository.readChapter(book, earlyReturn: true));
    _presenter.update(book);
    LoadingHandlerService.displaySuccess();
  }

  Future<void> _postpone(BookViewModel book) async {
    LoadingHandlerService.displayLoading();
    _service.postpone(book);
    await _exceptionHandler.wrapAsync(() async => await _repository.postpone(book, earlyReturn: true));
    _presenter.update(book);
    LoadingHandlerService.displaySuccess();
  }
}