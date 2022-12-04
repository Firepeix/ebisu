import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/http/response.dart';

typedef Json = Map<String, dynamic>;
typedef Query = Map<String, dynamic>;

abstract class Request<Response> {
  String endpoint();

  Json? body() => null;

  Query? query() => null;

  Response createResponse(Json body) {
    final name = Response.toString();
    
    if (name.startsWith("Success")) {
      return Success(body["message"]) as Response;
    }

    throw UnimplementedError("Para bodies desconhecidos deve-se implementar createResponse");
  }

  bool hasCustomError() => false;
}

abstract class RequestWithError<Response, Error extends ResultError> extends Request<Response> {
  bool hasCustomError() => true;

  Error createError(ErrorResponse response);
}
