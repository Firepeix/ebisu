import 'dart:convert';

import 'package:ebisu/shared/configuration/app_configuration.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

typedef DecodeJson<R> = R Function(Map<dynamic, dynamic>);

enum HttpError implements ResultError {
  UNKNOWN("Error Desconhecido", 1001);

  final String message;
  final int code;
  final dynamic details;

  const HttpError(this.message, this.code, { this.details });
}

@singleton
class Caron {
  AppConfiguration _config = AppConfiguration();

  Uri _url(String endpoint) {
    final host = _config.ebisuEndpoint.split("://");
    if (host[0] == "http") {
      return Uri.http(host[1], endpoint);
    }

    return Uri.https(host[1], endpoint);
  }

  Future<Result<R, ResultError>> get<R>(String endpoint, DecodeJson<R> decoder) async {
    try {
      final response = await http.get(_url(endpoint));
      return Result(decoder(jsonDecode(response.body)), null);
    } catch(error) {
      // TODO - ADD LOG
      print(error);
      return Result(null, HttpError.UNKNOWN);
    }
  }
}