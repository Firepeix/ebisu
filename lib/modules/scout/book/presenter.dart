import 'package:ebisu/modules/scout/book/interactor.dart';
import 'package:ebisu/modules/scout/book/navigator.dart';
import 'package:ebisu/modules/scout/book/views/books.dart';
import 'package:ebisu/shared/dependency/dependency_container.dart';
import 'package:ebisu/shared/services/notification_service.dart';
import 'package:ebisu/ui_components/chronos/colors/colors.dart';
import 'package:ebisu/ui_components/chronos/dialogs/select_dialog.dart';
import 'package:flutter/material.dart';

import 'models/book.dart';

class BookPresenter {
  late final _navigator = BookNavigator(this);
  final NotificationService _notificationService;

  BookPresenter(this._notificationService);

  void init() {
    _navigator.goToInitialRoute();
  }

  Widget initWidget() => BooksView(DependencyManager.get<BookInteractorInterface>());

  void setBooks(BookListState list, List<BookViewModel> books, {BookActionCallback? onBookTap}) {
    final List<BookViewModel> _books = [];
    books.sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));
    books.forEach((element) {
      element.onTap.action = onBookTap;
      _books.add(element);
    });
    list.books = _books;
  }

  void update(BookViewModel book) {
    book.save();
  }

  Future<BookAction?> presentBookActions(BookViewModel book) async {
    final postponeOption = SelectOption("Adiar", BookAction.POSTPONE, invert: true, icon: Icon(Icons.calendar_today, color: EColor.accent,));
    final activateOption = SelectOption("Ativar", BookAction.ACTIVATE, invert: true, icon: Icon(Icons.play_arrow, color: EColor.secondary,));


    final options = [
      SelectOption("Lido", BookAction.MARK_AS_READ, icon: Icon(Icons.check, color: EColor.success,)),
      book.isIgnored ? activateOption : postponeOption
    ];

    return await _notificationService.displaySelectDialog(book.name, options, appendix: book.statusName);
  }
}
