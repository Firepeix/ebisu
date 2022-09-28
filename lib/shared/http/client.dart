import 'dart:convert';

import 'package:ebisu/main.dart';
import 'package:ebisu/modules/auth/domain/services/auth_service.dart';
import 'package:ebisu/modules/auth/pages/login_page.dart';
import 'package:ebisu/modules/configuration/domain/repositories/config_repository.dart';
import 'package:ebisu/shared/dependency/dependency_container.dart';
import 'package:ebisu/shared/exceptions/handler.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/http/codes.dart';
import 'package:ebisu/shared/http/mapper.dart';
import 'package:ebisu/shared/services/notification_service.dart';
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
  ConfigRepositoryInterface _configRepository;
  late AuthServiceInterface _authService;

  Caron(this._mapper, this._configRepository, NotificationService notificationService, ExceptionHandlerInterface exceptionHandlerInterface) {
    _authService = AuthService(this, notificationService, exceptionHandlerInterface, _configRepository);
  }

  Future<Uri> _url(String endpoint) async {
    final url = await _configRepository.getEndpointUrl();
    final host = url.split("://");
    if (host[0] == "http") {
      return Uri.http(host[1], endpoint);
    }
    return Uri.https(host[1], endpoint);
  }

  Future<Map<String, String>?> _headers() async {
    final token = await _configRepository.getAuthToken();

    return {
      "Authorization": "Bearer $token"
    };
  }

  Future<Result<DataResponse<V>, ResultError>> get<V>(String endpoint, DecodeJson<V> decoder, {DecodeError? errorDecoder}) async {
    try {
      final response = await http.get(await _url(endpoint), headers: await _headers());
      return _parsePayload<DataResponse<V>, V>(response, decoder: decoder, errorDecoder: errorDecoder);
    } catch(error) {
      return _parseError(error: error);
    }
  }

  Future<Result<ListResponse<V>, ResultError>> getList<V>(String endpoint, DecodeJson<V> decoder, {DecodeError? errorDecoder}) async {
    try {
      final response = await http.get(await _url(endpoint), headers: await _headers());
      return _parsePayload<ListResponse<V>, V>(response, decoder: decoder, errorDecoder: errorDecoder);
    } catch(error) {
      return _parseError(error: error);
    }
  }

  Future<Result<R, ResultError>> post<R extends Response, B>(String endpoint, B body, EncodeJson<B> encoder, {DecodeJson<R>? decoder, DecodeError? errorDecoder}) async {
    try {
      final response = await http.post(await _url(endpoint), body: jsonEncode(encoder(body)), headers: await _headers());
      return _parsePayload<R, R>(response, decoder: decoder ?? _mapper.fromSuccessJson as DecodeJson<R>, errorDecoder: errorDecoder);
    } catch(error) {
      return _parseError(error: error);
    }
  }

  Future<Result<R, ResultError>> put<R extends Response, B>(String endpoint, B body, EncodeJson<B> encoder, {DecodeJson<R>? decoder, DecodeError? errorDecoder}) async {
    try {
      final response = await http.put(await _url(endpoint), body: jsonEncode(encoder(body)), headers: await _headers());
      return _parsePayload<R, R>(response, decoder: decoder ?? _mapper.fromSuccessJson as DecodeJson<R>, errorDecoder: errorDecoder);
    } catch(error) {
      return _parseError(error: error);
    }
  }

  Future<Result<R, ResultError>> delete<R extends Response>(String endpoint, {DecodeError? errorDecoder}) async {
      try {
        final response = await http.delete(await _url(endpoint), headers: await _headers());
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
        final context = DependencyManager.getContext();
        if (context != null) {
          routeTo(context, LoginPage(_authService));
        }
        return Result(null, HttpError.unauthorized());
      }

      final errorResponse = _mapper.fromErrorJson(jsonDecode(response.body), response.statusCode);
      return Result(null, errorDecoder?.call(errorResponse) ?? HttpError.server(Details(messageAddon: errorResponse.message)));
    }
    print(error);
    return Result(null, HttpError.unknown());
  }
}