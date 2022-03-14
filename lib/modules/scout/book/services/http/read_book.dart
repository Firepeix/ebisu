import 'package:ebisu/shared/http/request.dart';
import 'package:ebisu/shared/http/response.dart';

class ReadBookRequestBody implements CommandCentralRequest<ReadBookResponse> {
  final String id;

  ReadBookRequestBody(this.id);

  @override
  Map<String, dynamic> json() {
    return {
      "id": id
    };
  }

  @override
  ReadBookResponse createResponse(CommandResponse commandResponse) {
    final response = commandResponse.decode();
    return ReadBookResponse(response['success'].toString(), response);
  }
}


class ReadBookResponse extends CommandCentralResponse {
  ReadBookResponse(String success, Map<String, dynamic> rawResponse) : super(success, rawResponse);
}