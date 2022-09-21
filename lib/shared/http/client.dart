import 'dart:convert';

import 'package:ebisu/shared/configuration/app_configuration.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/http/codes.dart';
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
  const HttpError.unauthorized() : super("Acesso negado ao acessar o servidor", "U3", null) ;
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

  Map<String, String>? _headers() {
    return {
      "Authorization": "Bearer ${_config.authToken}"
    };
  }

  Future<Result<DataResponse<V>, ResultError>> get<V>(String endpoint, DecodeJson<V> decoder, {DecodeError? errorDecoder}) async {
    try {
      final response = await http.get(_url(endpoint), headers: _headers());
      return _parsePayload<DataResponse<V>, V>(response, decoder: decoder, errorDecoder: errorDecoder);
    } catch(error) {
      return _parseError(error: error);
    }
  }

  Future<Result<ListResponse<V>, ResultError>> getList<V>(String endpoint, DecodeJson<V> decoder, {DecodeError? errorDecoder}) async {
    try {
      final response = await http.get(_url(endpoint), headers: _headers());
      return _parsePayload<ListResponse<V>, V>(response, decoder: decoder, errorDecoder: errorDecoder);
    } catch(error) {
      return _parseError(error: error);
    }
  }

  Future<Result<R, ResultError>> post<R extends Response, B>(String endpoint, B body, EncodeJson<B> encoder, {DecodeJson<R>? decoder, DecodeError? errorDecoder}) async {
    try {
      final response = await http.post(_url(endpoint), body: jsonEncode(encoder(body)), headers: _headers());
      return _parsePayload<R, R>(response, decoder: decoder ?? _mapper.fromSuccessJson as DecodeJson<R>, errorDecoder: errorDecoder);
    } catch(error) {
      return _parseError(error: error);
    }
  }

  Future<Result<R, ResultError>> put<R extends Response, B>(String endpoint, B body, EncodeJson<B> encoder, {DecodeJson<R>? decoder, DecodeError? errorDecoder}) async {
    try {
      final response = await http.put(_url(endpoint), body: jsonEncode(encoder(body)), headers: _headers());
      return _parsePayload<R, R>(response, decoder: decoder ?? _mapper.fromSuccessJson as DecodeJson<R>, errorDecoder: errorDecoder);
    } catch(error) {
      return _parseError(error: error);
    }
  }

  Future<Result<R, ResultError>> delete<R extends Response>(String endpoint, {DecodeError? errorDecoder}) async {
      try {
        final response = await http.delete(_url(endpoint), headers: _headers());
        return _parsePayload<R, String>(response, successResponse: Success("Elemento deletado com sucesso!") as R);
      } catch(error) {
        return _parseError(error: error);
      }
  }

  Result<R, ResultError> _parsePayload<R extends Response, V>(http.Response response, {DecodeJson<V>? decoder, DecodeError? errorDecoder, R? successResponse}) {
    if (response.statusCode.toString().startsWith("2")) {
      if (successResponse != null) {
        return Result(successResponse, null);
      }

      final ResultError? error = null;
      final payload = _mapper.fromResponse<R, V>(jsonDecode(response.body), decoder);
      return Result(payload as R, error);
    }

    return _parseError(response: response, errorDecoder: errorDecoder);
  }

  Result<R, ResultError> _parseError<R extends Response, V>({http.Response? response, DecodeError? errorDecoder, Object? error}) {
    // TODO - ADD LOG
    if (response != null) {
      print(response.reasonPhrase);
      if(response.statusCode == HttpCodes.Unauthorized) {
        return Result(null, HttpError.unauthorized());
      }

      final errorResponse = _mapper.fromErrorJson(jsonDecode(response.body), response.statusCode);
      return Result(null, errorDecoder?.call(errorResponse) ?? HttpError.server(Details(messageAddon: errorResponse.message)));
    }
    print(error);
    return Result(null, HttpError.unknown());
  }
}