
import 'package:ebisu/modules/scout/book/models/book.dart';
import 'package:ebisu/modules/scout/book/models/book_hive_model.dart';
import 'package:ebisu/shared/http/request.dart';
import 'package:ebisu/shared/http/response.dart';
import 'package:ebisu/shared/http/sheet_integration.dart';
import 'package:ebisu/ui_components/chronos/time/moment.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

enum CentralCommands {
  GET_BOOKS
}

abstract class BookRepositoryInterface {
  Future<List<BookViewModel>> getBooks(bool includeAll, {bool cacheLess: false});
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
      await _saveInCache(response._books);
      return Future.value(response._books);
    }

    return _getFromCache();
  }

  Future<Box> _getBox() async {
    return await Hive.openBox<BookHiveModel>(BOX);
  }

  Future<void> _saveInCache(List<BookViewModel> _books) async {
    final box = await _getBox();
    _books.forEach((book) async => await box.add(BookHiveModel(book.id, book.name, book.chapter.value, book.ignoreUntil.toString())));
  }

  Future<List<BookViewModel>> _getFromCache() async {
    final box = await _getBox();
    final books = box.values.map((book) {
      final ignoredUntil = book.ignoreUntil != "null" ? Moment.parse(book.ignoreUntil) : null;
      return BookViewModel(book.title, BookChapter(book.chapter), id: book.id, ignoreUntil: ignoredUntil);
    }).toList();
    return Future.value(books);
  }

}

class GetBooksRequestBody implements CommandCentralRequest<GetBooksResponse> {
  final bool includeIgnored;

  GetBooksRequestBody({this.includeIgnored = false});


  @override
  Map<String, dynamic> json() {
    return {
      "includeIgnored": includeIgnored
    };
  }

  @override
  GetBooksResponse createResponse(CommandResponse commandResponse) {
    final response = commandResponse.decode();
    return GetBooksResponse(response['success'].toString(), response);
  }
}

class GetBooksResponse extends CommandCentralResponse {
  final List<BookViewModel> _books = [];

  List<BookViewModel> get books => _books;

  GetBooksResponse(String success, Map<String, dynamic> rawResponse) : super(success, rawResponse) {
    final List rawBooks = rawResponse["data"] ?? [];
    rawBooks.forEach((rawBook) => _books.add(_createBook(rawBook)));
  }

  BookViewModel _createBook(Map<String, dynamic> rawBook) {
    final ignoreUntil = rawBook["ignoredUntil"] == "" || rawBook["ignoredUntil"] == null ? null : Moment.parse(rawBook["ignoredUntil"]);
    return BookViewModel(rawBook["title"], BookChapter(rawBook["lastChapterRead"]), id: rawBook["id"], ignoreUntil: ignoreUntil,);
  }
}