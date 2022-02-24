import 'package:ebisu/modules/scout/book/models/book.dart';
import 'package:ebisu/modules/scout/book/presenter.dart';
import 'package:ebisu/modules/scout/book/services/repository.dart';
import 'package:ebisu/modules/scout/book/services/service.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

abstract class BookInteractorInterface {
  void init();
  Widget getDrawer();
  List<BookViewModel> getBooks();
}

@Injectable(as: BookInteractorInterface)
class BookInteractor implements BookInteractorInterface {
  final BookServiceInterface _service;
  final BookRepositoryInterface _repository;

  BookInteractor(this._service, this._repository);

  final _presenter = BookPresenter();

  @override
  void init() => _presenter.init();

  @override
  Widget getDrawer() => _service.getDrawer();

  @override
  List<BookViewModel> getBooks() {
    _repository.getBooks(true);
    return [];
  }
}