import 'package:ebisu/modules/scout/book/models/book.dart';
import 'package:ebisu/modules/scout/book/services/http/clean_logs.dart';
import 'package:ebisu/modules/scout/book/services/http/expedite.dart';
import 'package:ebisu/modules/scout/book/services/http/postpone.dart';
import 'package:ebisu/modules/scout/book/services/http/read_book.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/exceptions/result_error.dart';
import 'package:ebisu/shared/http/client.dart';
import 'package:ebisu/shared/http/response.dart';
import 'package:injectable/injectable.dart';
import 'http/get_books.dart';

typedef BookMethod = Future<void> Function(BookModel book, {bool earlyReturn});

enum CentralCommands { GET_BOOKS, EXPEDITE_BOOK, READ_BOOK, POSTPONE_BOOK, CLEAN_LOGS }

abstract class BookRepositoryInterface {
  Future<Result<List<BookModel>, ResultError>> getBooks(bool includeAll);
  Future<Result<Success, ResultError>> expedite(BookModel book);
  Future<Result<Success, ResultError>> readChapter(BookModel book);
  Future<Result<Success, ResultError>> postpone(BookModel book);
  Future<Result<Success, ResultError>> cleanLogs();
}

class Endpoint {
  static const Index = "books";
  static const Book = "books/:bookId";
  static const Expedite = "${Endpoint.Book}/turn-on";
  static const Read = "${Endpoint.Book}/read";
  static const Postpone = "${Endpoint.Book}/postpone";
  static const Logs = "logs";
}

@Injectable(as: BookRepositoryInterface)
class BookRepository implements BookRepositoryInterface {
  static const BOX = 'books';
  final Tank _tank;

  BookRepository(this._tank);

  @override
  Future<Result<List<BookModel>, ResultError>> getBooks(bool includeAll) async {
    try {
      final request = GetBooksRequest(includeIgnored: includeAll);
      return await _tank.get(request);
    } catch (error) {
      return Err(UnknownError(error));
    }
  }

  @override
  Future<Result<Success, ResultError>> expedite(BookModel book) async {
    return await _tank.put(ExpediteRequest(book.id));
  }

  @override
  Future<Result<Success, ResultError>> readChapter(BookModel book, {earlyReturn: false}) async {
    return await _tank.put(ReadChapterOfBookRequest(book.id));
  }

  @override
  Future<Result<Success, ResultError>> postpone(BookModel book, {earlyReturn: false}) async {
    return await _tank.put(PostponeRequest(book.id));
  }

  @override
  Future<Result<Success, ResultError>> cleanLogs() async {
     return await _tank.delete(ClearLogRequest());
  }
}
