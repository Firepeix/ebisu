import 'package:ebisu/main.dart';
import 'package:ebisu/modules/core/core.dart';
import 'package:ebisu/modules/scout/book/interactor.dart';
import 'package:ebisu/modules/scout/book/models/book.dart';
import 'package:ebisu/modules/scout/book/services/repository.dart';
import 'package:ebisu/shared/exceptions/handler.dart';
import 'package:ebisu/shared/services/notification_service.dart';
import 'package:ebisu/ui_components/chronos/time/moment.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

abstract class BookServiceInterface {
  void init();
  Widget getDrawer();
  BookModel activate(BookModel book);
  BookModel readChapter(BookModel book);
  BookModel postpone(BookModel book);
}

@Injectable(as: BookServiceInterface)
class BookService implements BookServiceInterface {
  final CoreInterface _coreInterface;
  late final _interactor = BookInteractor(this, getIt<BookRepositoryInterface>(),
      getIt<ExceptionHandlerInterface>(), getIt<NotificationService>());

  BookService(this._coreInterface);

  @override
  void init() => _interactor.init();

  Widget getDrawer() => _coreInterface.getDrawer();

  @override
  BookModel activate(BookModel book) {
    return BookModel(id: book.id, name: book.name, chapter: book.chapter, ignoredUntil: null);
  }

  @override
  BookModel postpone(BookModel book) {
    return BookModel(id: book.id, name: book.name, chapter: book.chapter, ignoredUntil: Moment.now().add(Duration(days: 365)));
  }

  @override
  BookModel readChapter(BookModel book) {
    return BookModel(id: book.id, name: book.name, chapter: book.chapter.increment(), ignoredUntil: book.ignoredUntil);
  }
}
