
import 'package:ebisu/modules/scout/book/models/book.dart';
import 'package:ebisu/shared/http/request.dart';
import 'package:ebisu/shared/http/sheet_integration.dart';
import 'package:injectable/injectable.dart';

enum CentralCommands {
  GET_BOOKS
}

abstract class BookRepositoryInterface {
  Future<List<BookViewModel>> getBooks(bool includeAll);
}

@Injectable(as: BookRepositoryInterface)
class BookRepository implements BookRepositoryInterface {
  final CommandCentralInterface _central;

  BookRepository(this._central);

  @override
  Future<List<BookViewModel>> getBooks(bool includeAll) async {
    await _central.execute(CentralCommands.GET_BOOKS.name, GetBooksRequestBody(includeIgnored: true));
    return Future.value([]);
  }

}

class GetBooksRequestBody implements CommandCentralRequest {
  final bool includeIgnored;

  GetBooksRequestBody({this.includeIgnored = false});


  @override
  Map<String, dynamic> json() {
    return {
      "includeIgnored": includeIgnored
    };
  }
}