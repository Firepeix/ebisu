import 'package:ebisu/modules/scout/book/services/repository.dart';
import 'package:ebisu/shared/http/request.dart';
import 'package:ebisu/shared/http/response.dart';

class PostponeRequest extends Request<Success> {
  final String id;

  PostponeRequest(this.id);

  @override
  String endpoint() {
    return Endpoint.Postpone.replaceFirst(":bookId", id);
  }
}

