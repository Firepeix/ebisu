import 'dart:convert';

import 'package:ebisu/shared/configuration/app_configuration.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/http/mapper.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import 'response.dart';

typedef DecodeJson<R> = R Function(Map<dynamic, dynamic>);
typedef EncodeJson<B> = Map<dynamic, dynamic> Function(B body);
typedef DecodeError = ResultError Function(ErrorResponse response);

class HttpError extends ResultError {
  const HttpError.unknown() : super("Ops! Ocorreu um erro. Tente Novamente mais tarde.", "U1", null) ;
  const HttpError.server(details) : super(null, "U2", details) ;
}

@singleton
class Caron {
  Mapper _mapper;

  Caron(this._mapper);

  AppConfiguration _config = AppConfiguration();

  Uri _url(String endpoint) {
    final host = _config.ebisuEndpoint.split("://");
    if (host[0] == "http") {
      return Uri.http(host[1], endpoint);
    }

    return Uri.https(host[1], endpoint);
  }

  Future<Result<R, ResultError>> get<R>(String endpoint, DecodeJson<R> decoder, {DecodeError? errorDecoder}) async {
    try {
      final response = await http.get(_url(endpoint));
      if (response.statusCode.toString().startsWith("2")) {
        return Result(decoder(jsonDecode(response.body)), null);
      }
      // TODO - ADD LOG
      print(response.reasonPhrase);
      final errorResponse = _mapper.fromErrorJson(jsonDecode(response.body), response.statusCode);
      return Result(null, errorDecoder?.call(errorResponse) ?? HttpError.server(Details(messageAddon: errorResponse.message)));
    } catch(error) {
      // TODO - ADD LOG
      print(error);
      return Result(null, HttpError.unknown());
    }
  }

  Future<Result<R, ResultError>> post<R extends Response, B>(String endpoint, B body, EncodeJson<B> encoder, {DecodeJson<R>? decoder, DecodeError? errorDecoder}) async {
    try {
      final response = await http.post(_url(endpoint), body: jsonEncode(encoder(body)));
      final responseDecode = decoder ?? _mapper.fromSuccessJson;
      final ResultError? error = null;
      if (response.statusCode.toString().startsWith("2")) {
        return Result(responseDecode(jsonDecode(response.body)), error).mapTo<R>();
      }
      // TODO - ADD LOG
      print(response.reasonPhrase);
      final errorResponse = _mapper.fromErrorJson(jsonDecode(response.body), response.statusCode);
      return Result(null, errorDecoder?.call(errorResponse) ?? HttpError.server(Details(messageAddon: errorResponse.message)));
    } catch(error) {
      // TODO - ADD LOG
      print(error);
      return Result(null, HttpError.unknown());
    }
  }

  Future<Result<R, ResultError>> delete<R extends Response>(String endpoint, {DecodeError? errorDecoder}) async {
    try {
      final response = await http.delete(_url(endpoint));
      final ResultError? error = null;
      if (response.statusCode.toString().startsWith("2")) {
        return Result(Success("Elemento deletado com sucesso!"), error).mapTo<R>();
      }
      // TODO - ADD LOG
      print(response.reasonPhrase);
      final errorResponse = _mapper.fromErrorJson(jsonDecode(response.body), response.statusCode);
      return Result(null, errorDecoder?.call(errorResponse) ?? HttpError.server(Details(messageAddon: errorResponse.message)));
    } catch(error) {
      // TODO - ADD LOG
      print(error);
      return Result(null, HttpError.unknown());
    }
  }
}