import 'package:ebisu/shared/http/response.dart';
import 'package:injectable/injectable.dart';



@injectable
class Mapper {
  Success fromSuccessJson(Map<dynamic, dynamic> json) {
    return Success(json["message"]);
  }

  ErrorResponse fromErrorJson(Map<dynamic, dynamic> json, int code) {
    return ErrorResponse(code, json["business_code"], json["message"]);
  }
}