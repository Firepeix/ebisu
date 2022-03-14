import 'package:ebisu/shared/http/request.dart';
import 'package:ebisu/shared/http/response.dart';

class ExpediteRequestBody implements CommandCentralRequest<ExpediteResponse> {
  final String id;

  ExpediteRequestBody(this.id);

  @override
  Map<String, dynamic> json() {
    return {
      "id": id
    };
  }

  @override
  ExpediteResponse createResponse(CommandResponse commandResponse) {
    final response = commandResponse.decode();
    return ExpediteResponse(response['success'].toString(), response);
  }
}


class ExpediteResponse extends CommandCentralResponse {
  ExpediteResponse(String success, Map<String, dynamic> rawResponse) : super(success, rawResponse);
}