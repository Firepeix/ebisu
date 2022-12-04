import 'package:ebisu/modules/scout/book/models/book.dart';
import 'package:ebisu/modules/scout/book/presenter.dart';
import 'package:ebisu/modules/scout/book/services/repository.dart';
import 'package:ebisu/modules/scout/book/services/service.dart';
import 'package:ebisu/shared/exceptions/handler.dart';
import 'package:ebisu/shared/services/notification_service.dart';
import 'package:ebisu/shared/utils/matcher.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

abstract class BookInteractorInterface {
  void init();
  Widget getDrawer();
  Future<List<BookModel>> getBooks();
  Future<void> onCleanLogsTap();
  Future<BookModel> onBookTap(BookModel book);
}

@Injectable(as: BookInteractorInterface)
class BookInteractor implements BookInteractorInterface {
  final BookServiceInterface _service;
  final BookRepositoryInterface _repository;
  late final BookPresenter _presenter;
  final ExceptionHandlerInterface _exceptionHandler;

  BookInteractor(
      this._service, this._repository, this._exceptionHandler, NotificationService _notificationService) {
    _presenter = BookPresenter(_notificationService, this, _exceptionHandler);
  }

  @override
  void init() => _presenter.init();

  @override
  Widget getDrawer() => _service.getDrawer();

  @override
  Future<List<BookModel>> getBooks() async {
    final result = await _repository.getBooks(true);
    return _exceptionHandler.expect(result) ?? [];
  }

  @override
  Future<void> onCleanLogsTap() async {
    await _presenter.presentAction(() async => await _repository.cleanLogs());
  }

  @override
  Future<BookModel> onBookTap(BookModel book) async {
    final action = await _presenter.presentBookActions(book);
    if (action != null) {
      return Matcher.matchAsyncWhen(action, {
        BookAction.ACTIVATE: () async => await _activateBook(book),
        BookAction.MARK_AS_READ: () async => await _readChapter(book),
        BookAction.POSTPONE: () async => await _postpone(book)
      });
    }

    return book;
  }

  Future<BookModel> _activateBook(BookModel book) async {
    final result = await _presenter.presentAction(() async => await _repository.expedite(book));
    if (result.isOk()) {
      return _service.activate(book);
    }
    return book;
  }

  Future<BookModel> _readChapter(BookModel book) async {
    final result = await _presenter.presentAction(() async => await _repository.readChapter(book));
    if (result.isOk()) {
      return _service.readChapter(book);
    }
    return book;
  }

  Future<BookModel> _postpone(BookModel book) async {
    final result = await _presenter.presentAction(() async => await _repository.postpone(book));
    if (result.isOk()) {
      return _service.postpone(book);
    }
    return book;
  }
}
