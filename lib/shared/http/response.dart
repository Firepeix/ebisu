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