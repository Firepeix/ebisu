import 'package:ebisu/modules/scout/book/services/repository.dart';
import 'package:ebisu/shared/http/request.dart';
import 'package:ebisu/shared/http/response.dart';

class ClearLogRequest extends Request<Success> {
  @override
  String endpoint() {
    return Endpoint.Logs;
  }
}