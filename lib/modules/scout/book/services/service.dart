import 'package:ebisu/modules/core/core.dart';
import 'package:ebisu/modules/scout/book/interactor.dart';
import 'package:ebisu/modules/scout/book/models/book.dart';
import 'package:ebisu/modules/scout/book/services/repository.dart';
import 'package:ebisu/shared/Domain/Services/ExpcetionHandlerService.dart';
import 'package:ebisu/shared/dependency/dependency_container.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

abstract class BookServiceInterface {
  void init();
  Widget getDrawer();
  void activateBook(BookViewModel book);
}

@Injectable(as: BookServiceInterface)
class BookService implements BookServiceInterface {
  final CoreInterface _coreInterface;
  late final BookInteractor _interactor = BookInteractor(this, DependencyManager.get<BookRepositoryInterface>(), DependencyManager.get<ExceptionHandlerServiceInterface>());

  BookService(this._coreInterface);


  @override
  void init() => _interactor.init();

  Widget getDrawer() => _coreInterface.getDrawer();

  @override
  void activateBook(BookViewModel book) {
    book.ignoreUntil = null;
  }
}