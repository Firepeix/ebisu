import 'dart:convert';

import 'package:ebisu/shared/configuration/app_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

typedef DecodeJson<R> = R Function(Map<dynamic, dynamic>);

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

  Future<R> get<R>(String endpoint, DecodeJson<R> decoder) async {
    final response = await http.get(_url(endpoint));
    return decoder(jsonDecode(response.body));
  }
}