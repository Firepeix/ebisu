import 'package:ebisu/shared/http/request.dart';
import 'package:ebisu/shared/http/response.dart';

class CleanLogsRequestBody implements CommandCentralRequest<CleanLogsResponse> {
  @override
  Map<String, dynamic> json() {
    return {};
  }

  @override
  CleanLogsResponse createResponse(CommandResponse commandResponse) {
    final response = commandResponse.decode();
    return CleanLogsResponse(response['success'].toString(), response);
  }
}


class CleanLogsResponse extends CommandCentralResponse {
  CleanLogsResponse(String success, Map<String, dynamic> rawResponse) : super(success, rawResponse);
}