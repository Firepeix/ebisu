import 'package:ebisu/modules/scout/book/services/repository.dart';
import 'package:ebisu/shared/http/request.dart';
import 'package:ebisu/shared/http/response.dart';

class ExpediteRequest extends Request<Success> {
  final String id;

  ExpediteRequest(this.id);

  @override
  String endpoint() {
    return Endpoint.Expedite.replaceFirst(":bookId", id);
  }
}
