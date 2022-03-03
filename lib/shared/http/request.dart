import 'package:ebisu/shared/http/response.dart';

abstract class CommandCentralRequest<R> {
  Map<String, dynamic> json();
  R createResponse(CommandResponse commandResponse);
}