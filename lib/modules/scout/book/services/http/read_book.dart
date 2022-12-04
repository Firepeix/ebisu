import 'package:ebisu/modules/scout/book/services/repository.dart';
import 'package:ebisu/shared/http/request.dart';
import 'package:ebisu/shared/http/response.dart';

class ReadChapterOfBookRequest extends Request<Success> {
  final String id;

  ReadChapterOfBookRequest(this.id);

  @override
  String endpoint() {
    return Endpoint.Read.replaceFirst(":bookId", id);
  }
}
