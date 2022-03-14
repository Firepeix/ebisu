
import 'package:ebisu/modules/scout/book/models/book.dart';
import 'package:ebisu/shared/http/request.dart';
import 'package:ebisu/shared/http/response.dart';
import 'package:ebisu/ui_components/chronos/time/moment.dart';

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