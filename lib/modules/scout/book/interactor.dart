import 'package:ebisu/modules/scout/book/models/book.dart';
import 'package:ebisu/modules/scout/book/presenter.dart';
import 'package:ebisu/modules/scout/book/services/repository.dart';
import 'package:ebisu/modules/scout/book/services/service.dart';
import 'package:ebisu/shared/Domain/Services/ExpcetionHandlerService.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

abstract class BookInteractorInterface {
  void init();
  Widget getDrawer();
  Future<List<BookViewModel>> getBooks({bool cacheLess: false});
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

  @override
  Future<List<BookViewModel>> getBooks({bool cacheLess: false}) async {
    final books = await _exceptionHandler.wrapAsync(() async => await _repository.getBooks(true, cacheLess: cacheLess));
    return Future.value(books);
  }
}