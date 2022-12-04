import 'package:ebisu/main.dart';
import 'package:ebisu/modules/scout/book/domain/mappers/book_mapper.dart';
import 'package:ebisu/modules/scout/book/models/book.dart';
import 'package:ebisu/modules/scout/book/services/repository.dart';
import 'package:ebisu/shared/http/request.dart';
import 'package:ebisu/shared/http/response.dart';

class GetBooksRequest extends Request<List<BookModel>> {
  final _mapper = getIt<BookMapper>();

  final bool includeIgnored;

  GetBooksRequest({this.includeIgnored = false});

  @override
  String endpoint() {
    return Endpoint.Index;
  }

  @override
  List<BookModel> createResponse(Json response) {
    return ListResponse.raw(response, _mapper.fromJson).data;
  }

  @override
  Query query() {
    return {"includeIgnored": includeIgnored};
  }
}
