import 'package:ebisu/modules/scout/book/interactor.dart';
import 'package:ebisu/modules/scout/book/navigator.dart';
import 'package:ebisu/modules/scout/book/views/books.dart';
import 'package:ebisu/shared/exceptions/handler.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/exceptions/result_error.dart';
import 'package:ebisu/shared/http/response.dart';
import 'package:ebisu/shared/services/notification_service.dart';
import 'package:ebisu/ui_components/chronos/colors/colors.dart';
import 'package:ebisu/ui_components/chronos/dialogs/select_dialog.dart';
import 'package:flutter/material.dart';

import 'models/book.dart';

class BookPresenter {
  late final _navigator = BookNavigator(this);
  final NotificationService _notificationService;
  final BookInteractorInterface _interactor;
  final ExceptionHandlerInterface _exceptionHandler;

  BookPresenter(this._notificationService, this._interactor, this._exceptionHandler);

  void init() {
    _navigator.goToInitialRoute();
  }

  Widget initWidget() => BooksView(_interactor);

  Future<BookAction?> presentBookActions(BookModel book) async {
    final postponeOption = SelectOption("Adiar", BookAction.POSTPONE,
        invert: true,
        icon: Icon(
          Icons.calendar_today,
          color: EColor.accent,
        ));
    final activateOption = SelectOption("Ativar", BookAction.ACTIVATE,
        invert: true,
        icon: Icon(
          Icons.play_arrow,
          color: EColor.secondary,
        ));

    final options = [
      SelectOption("Lido", BookAction.MARK_AS_READ,
          icon: Icon(
            Icons.check,
            color: EColor.success,
          )),
      book.isIgnored ? activateOption : postponeOption
    ];

    return await _notificationService.displaySelectDialog(book.name, options, appendix: book.statusName);
  }

  Future<Result<Success, ResultError>> presentAction(
      Future<Result<Success, ResultError>> Function() action) async {
    _notificationService.displayLoading();
    final result = await action();

    result.let(ok: (value) => _notificationService.displaySuccess(message: value.message));

    _exceptionHandler.expect(result);
    return result;
  }
}
