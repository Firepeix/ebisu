import 'package:ebisu/shared/http/request.dart';
import 'package:ebisu/shared/http/response.dart';

class PostponeRequestBody implements CommandCentralRequest<PostponeResponse> {
  final String id;

  PostponeRequestBody(this.id);

  @override
  Map<String, dynamic> json() {
    return {
      "id": id
    };
  }

  @override
  PostponeResponse createResponse(CommandResponse commandResponse) {
    final response = commandResponse.decode();
    return PostponeResponse(response['success'].toString(), response);
  }
}


class PostponeResponse extends CommandCentralResponse {
  PostponeResponse(String success, Map<String, dynamic> rawResponse) : super(success, rawResponse);
}