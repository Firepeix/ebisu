import 'dart:convert';

enum CommandCentralCode {
  error,
  success,
  in_progress
}


class CommandResponse {
  final CommandCentralCode code;
  final String response;

  CommandResponse(this.code, this.response) {
    _check();
  }

  void _check() {
    if (code == CommandCentralCode.error) {
      throw Error.safeToString(response);
    }
  }

  Map<String, dynamic> decode() {
    return jsonDecode(response);
  }
}

abstract class CommandCentralResponse {
  final String success;
  final Map<String, dynamic> rawResponse;

  CommandCentralResponse(this.success, this.rawResponse) {
    _check();
  }

  void _check() {
    if (success != "true") {
      throw Error.safeToString(rawResponse["error"]);
    }
  }
}

abstract class Response {

}

abstract class GenericResponse extends Response {
  String message;

  GenericResponse(this.message);
}

class Success extends GenericResponse {
  Success(super.message);
}

class TokenResponse extends DataResponse<String> {
  String get token => super.data;
  TokenResponse(super.message);
}

class ErrorResponse extends GenericResponse {
  String internalCode;
  int code;
  ErrorResponse(this.code, this.internalCode, super.message);
}

class DataResponse<T> extends Response {
  final T data;

  DataResponse(this.data);
}

class ListResponse<T> extends DataResponse<List<T>> {
  ListResponse(List<T> items) : super(items);
}