import 'package:ebisu/modules/scout/book/models/book.dart';
import 'package:ebisu/modules/scout/book/models/book_hive_model.dart';
import 'package:ebisu/modules/scout/book/services/http/clean_logs.dart';
import 'package:ebisu/shared/http/sheet_integration.dart';
import 'package:ebisu/ui_components/chronos/time/moment.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import 'http/expedite.dart';
import 'http/get_books.dart';
import 'http/postpone.dart';
import 'http/read_book.dart';

typedef BookMethod = Future<void> Function(BookViewModel book, { bool earlyReturn });

enum CentralCommands {
  GET_BOOKS,
  EXPEDITE_BOOK,
  READ_BOOK,
  POSTPONE_BOOK,
  CLEAN_LOGS
}

abstract class BookRepositoryInterface {
  Future<List<BookViewModel>> getBooks(bool includeAll, {bool cacheLess: false});
  Future<void> expedite(BookViewModel book, { earlyReturn: false });
  Future<void> readChapter(BookViewModel book, { earlyReturn: false });
  Future<void> postpone(BookViewModel book, { earlyReturn: false });
  Future<void> cleanLogs({ earlyReturn: false });
}

@Injectable(as: BookRepositoryInterface)
class BookRepository implements BookRepositoryInterface {
  static const BOX = 'books';
  final CommandCentralInterface _central;

  BookRepository(this._central);

  @override
  Future<List<BookViewModel>> getBooks(bool includeAll, {bool cacheLess: false}) async {
    if(cacheLess) {
      final response = await _central.execute(CentralCommands.GET_BOOKS.name, GetBooksRequestBody(includeIgnored: true));
      await _saveInCache(response.books);
      return Future.value(response.books);
    }

    return _getFromCache();
  }

  Future<Box> _getBox() async {
    return await Hive.openBox<BookHiveModel>(BOX);
  }

  Future<void> _saveInCache(List<BookViewModel> _books) async {
    final box = await _getBox();
    await box.clear();
    _books.forEach((book) async => await box.put(book.id, _toHiveModel(book)));
  }

  Future<List<BookViewModel>> _getFromCache() async {
    final box = await _getBox();
    final books = box.values.map((book) => _toViewModel(book)).toList();
    return Future.value(books);
  }

  BookHiveModel _toHiveModel(BookViewModel book) {
    return BookHiveModel(book.id, book.name, book.chapter.value, book.ignoreUntil.toString());
  }

  BookViewModel _toViewModel(BookHiveModel book) {
    final ignoredUntil = book.ignoreUntil != "null" && book.ignoreUntil != null ? Moment.parse(book.ignoreUntil!) : null;
    return BookViewModel(book.title, BookChapter(book.chapter), id: book.id, ignoreUntil: ignoredUntil);
  }

  // Early Return significa que vai esperar a operação no cache completar
  // mas não vai esperar a operação na API completar
  @override
  Future<void> expedite(BookViewModel book, { earlyReturn: false }) async {
    final box = await _getBox();
    await box.put(book.id, _toHiveModel(book));
    if (earlyReturn) {
      _central.execute(CentralCommands.EXPEDITE_BOOK.name, ExpediteRequestBody(book.id));
      return;
    }
    await _central.execute(CentralCommands.EXPEDITE_BOOK.name, ExpediteRequestBody(book.id));
  }

  // Early Return significa que vai esperar a operação no cache completar
  // mas não vai esperar a operação na API completar
  @override
  Future<void> readChapter(BookViewModel book, { earlyReturn: false }) async {
    final box = await _getBox();
    await box.put(book.id, _toHiveModel(book));
    if (earlyReturn) {
      _central.execute(CentralCommands.READ_BOOK.name, ReadBookRequestBody(book.id));
      return;
    }
    await _central.execute(CentralCommands.READ_BOOK.name, ReadBookRequestBody(book.id));
  }

  // Early Return significa que vai esperar a operação no cache completar
  // mas não vai esperar a operação na API completar
  @override
  Future<void> postpone(BookViewModel book, { earlyReturn: false }) async {
    final box = await _getBox();
    await box.put(book.id, _toHiveModel(book));
    if (earlyReturn) {
      _central.execute(CentralCommands.POSTPONE_BOOK.name, PostponeRequestBody(book.id));
      return;
    }
    await _central.execute(CentralCommands.POSTPONE_BOOK.name, PostponeRequestBody(book.id));
  }

  // Early Return significa que vai esperar a operação no cache completar
  // mas não vai esperar a operação na API completar
  @override
  Future<void> cleanLogs({ earlyReturn: false }) async {
    if (earlyReturn) {
      _central.execute(CentralCommands.CLEAN_LOGS.name, CleanLogsRequestBody());
      return;
    }
    await _central.execute(CentralCommands.POSTPONE_BOOK.name, CleanLogsRequestBody());
  }
}