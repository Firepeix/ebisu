import 'package:ebisu/shared/http/client.dart';
import 'package:ebisu/shared/http/response.dart';
import 'package:injectable/injectable.dart';

@injectable
class Mapper {

  Response fromResponse<R extends Response, B>(Map<dynamic, dynamic> json, DecodeJson<B>? decoder) {
    if (decoder == null) {
      return Success(json["message"]);
    }

    final name = R.toString();
    if (name.startsWith("ListResponse")) {
      return ListResponse<B>((json["data"] as List<dynamic>).map((e) => decoder(e)).toList()) as R;
    }

    if (name.startsWith("DataResponse")) {
      return DataResponse<B>(decoder(json["data"])) as R;
    }

    return Success("Sucesso");
  }

  Success fromSuccessJson(Map<dynamic, dynamic> json) {
    return Success(json["message"]);
  }

  ErrorResponse fromErrorJson(Map<dynamic, dynamic> json, int code) {
    return ErrorResponse(code, json["business_code"].toString(), json["message"]);
  }
}