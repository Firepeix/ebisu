import 'package:ebisu/modules/scout/book/interactor.dart';
import 'package:ebisu/modules/scout/book/navigator.dart';
import 'package:ebisu/modules/scout/book/views/books.dart';
import 'package:ebisu/shared/dependency/dependency_container.dart';
import 'package:flutter/material.dart';

class BookPresenter {
  late final _navigator = BookNavigator(this);

  void init() {
    _navigator.goToInitialRoute();
  }

  Widget initWidget() => BooksView(DependencyManager.get<BookInteractorInterface>());
}