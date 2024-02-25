import 'dart:convert';

import 'package:ebisu/main.dart';
import 'package:ebisu/modules/auth/domain/services/auth_service.dart';
import 'package:ebisu/modules/auth/pages/login_page.dart';
import 'package:ebisu/modules/configuration/domain/repositories/config_repository.dart';
import 'package:ebisu/modules/user/entry/component/user_context.dart';
import 'package:ebisu/shared/configuration/app_configuration.dart';
import 'package:ebisu/shared/dependency/dependency_container.dart';
import 'package:ebisu/shared/exceptions/handler.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/exceptions/result_error.dart';
import 'package:ebisu/shared/http/codes.dart';
import 'package:ebisu/shared/http/mapper.dart';
import 'package:ebisu/shared/http/request.dart';
import 'package:ebisu/shared/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import 'response.dart';

typedef DecodeJson<R> = R Function(Map<String, dynamic>);
typedef EncodeJson<B> = Map<dynamic, dynamic> Function(B body);
typedef DecodeError = ResultError Function(ErrorResponse response);

class HttpError extends ResultError {
  HttpError.unknown() : super("Ops! Ocorreu um erro. Tente Novamente mais tarde.", "U1", null);
  HttpError.server(details) : super(null, "U2", details);
  HttpError.unauthorized() : super("Acesso negado ao acessar o servidor", "U3", null);
}

@singleton
class Tank extends Caron {
  Tank(super.mapper, super.configRepository, super.notificationService, super.handler);

  @override
  Application getApplication() {
    return Application.Scout;
  }
}

@singleton
class Kebisu extends Caron {
  Kebisu(super.mapper, super.configRepository, super.notificationService, super.handler);

  @override
  Application getApplication() {
    return Application.Kebisu;
  }
}

@singleton
class Caron {
  Mapper _mapper;
  ConfigRepositoryInterface _configRepository;
  late ExceptionHandlerInterface _handler;
  late AuthServiceInterface _authService;

  Caron(this._mapper, this._configRepository, NotificationService notificationService, ExceptionHandlerInterface handler) {
    _handler = handler;
    _authService = AuthService(this, notificationService, _handler, _configRepository);
  }

  Application getApplication() {
    return Application.Ebisu;
  }

  Future<Uri> _url(String endpoint, {Query? query}) async {
    final url = await _configRepository.getEndpointUrl(getApplication());
    final host = url.split("://");
    final uri = host[1].split("/");
    final domain = uri[0];
    final path = uri.length > 1 ? "${uri[1]}/$endpoint" : endpoint;
    if (host[0] == "http") {
      return Uri.http(domain, path, mapQuery(query));
    }
    return Uri.https(domain, path, mapQuery(query));
  }

  Query? mapQuery(Query? query) {
    if (query == null) {
      return null;
    }
    return query.map((key, value) => MapEntry(key, value.toString()));
  }

  Future<Map<String, String>?> _headers() async {
    final token = await _configRepository.getAuthToken();

    return {"Authorization": "Bearer $token", "Content-Type": "application/json; charset=utf-8"};
  }

  Future<Result<V, ResultError>> get<V>(Request<V> request) async {
    try {
      final response =
          await http.get(await _url(request.endpoint(), query: request.query()), headers: await _headers());
      return _parse<V>(request, response);
    } catch (error) {
      return _parseError(error: error);
    }
  }

  Future<Result<V, ResultError>> post<V>(Request<V> request) async {
    try {
      final response = await http.post(await _url(request.endpoint()), headers: await _headers(), body: jsonEncode(request.body()));
      return _parse<V>(request, response);
    } catch (error) {
      return _parseError(error: error);
    }
  }

  Future<Result<DataResponse<V>, ResultError>> getLegacy<V>(String endpoint, DecodeJson<V> decoder,
      {DecodeError? errorDecoder}) async {
    try {
      final response = await http.get(await _url(endpoint), headers: await _headers());
      return _parsePayload<DataResponse<V>, V>(response, decoder: decoder, errorDecoder: errorDecoder);
    } catch (error) {
      return _parseError(error: error);
    }
  }

  Future<Result<ListResponse<V>, ResultError>> getList<V>(String endpoint, DecodeJson<V> decoder,
      {DecodeError? errorDecoder}) async {
    try {
      final response = await http.get(await _url(endpoint), headers: await _headers());
      return _parsePayload<ListResponse<V>, V>(response, decoder: decoder, errorDecoder: errorDecoder);
    } catch (error) {
      return _parseError(error: error);
    }
  }

  Future<Result<R, ResultError>> postLegacy<R extends Response, B>(String endpoint, B body, EncodeJson<B> encoder,
      {DecodeJson<R>? decoder, DecodeError? errorDecoder}) async {
    try {
      final response =
          await http.post(await _url(endpoint), body: jsonEncode(encoder(body)), headers: await _headers());
      return _parsePayload<R, R>(response,
          decoder: decoder ?? _mapper.fromSuccessJson as DecodeJson<R>, errorDecoder: errorDecoder);
    } catch (error) {
      return _parseError(error: error);
    }
  }

  Future<Result<V, ResultError>> put<V>(Request<V> request) async {
    try {
      final response =
          await http.put(await _url(request.endpoint()), body: request.body(), headers: await _headers());
      return _parse<V>(request, response);
    } catch (error) {
      return _parseError(error: error);
    }
  }

  Future<Result<R, ResultError>> putLegacy<R extends Response, B>(
      String endpoint, B body, EncodeJson<B> encoder,
      {DecodeJson<R>? decoder, DecodeError? errorDecoder}) async {
    try {
      final response =
          await http.put(await _url(endpoint), body: jsonEncode(encoder(body)), headers: await _headers());
      return _parsePayload<R, R>(response,
          decoder: decoder ?? _mapper.fromSuccessJson as DecodeJson<R>, errorDecoder: errorDecoder);
    } catch (error) {
      return _parseError(error: error);
    }
  }

  Future<Result<V, ResultError>> delete<V>(Request<V> request) async {
    try {
      final response = await http.delete(await _url(request.endpoint()), body: request.body(), headers: await _headers());
      return _parse<V>(request, response);
    } catch (error) {
      return _parseError(error: error);
    }
  }

  Future<Result<R, ResultError>> deleteLegacy<R extends Response>(String endpoint,
      {DecodeError? errorDecoder}) async {
    try {
      final response = await http.delete(await _url(endpoint), headers: await _headers());
      return _parsePayload<R, String>(response,
          successResponse: Success("Elemento deletado com sucesso!") as R);
    } catch (error) {
      return _parseError(error: error);
    }
  }

  Result<R, ResultError> _parse<R>(Request<R> request, http.Response response) {
    if (response.statusCode.toString().startsWith("2")) {
      if(request is EmptyRequest) {
        return Ok(request.createResponse({}));
      }
      return Ok(request.createResponse(jsonDecode(utf8.decode(response.bodyBytes))));
    }

    return Err(_loadError(request, response));
  }

  ResultError _loadError(Request request, http.Response response) {
    if (response.statusCode == HttpCodes.Unauthorized) {
      final context = DependencyManager.getContext();
      if (context != null) {
        routeTo(context, LoginPage(_authService));
      }
      return HttpError.unauthorized();
    }

    final errorResponse = _mapper.fromErrorJson(jsonDecode(utf8.decode(response.bodyBytes)), response.statusCode);

    if (request is RequestWithError) {
      return request.createError(errorResponse);
    }

    return HttpError.server(
        Details(messageAddon: "${errorResponse.message}", data: jsonDecode(utf8.decode(response.bodyBytes))));
  }

  Result<R, ResultError> _parsePayload<R extends Response, V>(http.Response response,
      {DecodeJson<V>? decoder, DecodeError? errorDecoder, R? successResponse}) {
    if (response.statusCode.toString().startsWith("2")) {
      if (successResponse != null) {
        return Ok(successResponse);
      }

      final payload = _mapper.fromResponse<R, V>(jsonDecode(utf8.decode(response.bodyBytes)), decoder);
      return Ok(payload as R);
    }

    return _parseError(response: response, errorDecoder: errorDecoder);
  }

  Result<R, ResultError> _parseError<R extends Response, V>(
      {http.Response? response, DecodeError? errorDecoder, Object? error}) {
    if (response != null) {
      if (response.statusCode == HttpCodes.Unauthorized) {
        final context = DependencyManager.getContext();
        if (context != null) {
          routeTo(context, UserContext(id: AppTheme.wewe, child: LoginPage(_authService), theme: AppConfiguration.weweTheme()));
        }
        return Err(HttpError.unauthorized());
      }

      final errorResponse = _mapper.fromErrorJson(jsonDecode(utf8.decode(response.bodyBytes)), response.statusCode);

      return Err(errorDecoder?.call(errorResponse) ??
              HttpError.server(
                  Details(messageAddon: "${errorResponse.message}", data: jsonDecode(utf8.decode(response.bodyBytes)))));
    }

    if (error != null) {
      return Err(_handler.parseError(error));
    }

    return Err(HttpError.unknown());
  }

  /// Esse método existe para que no futuro se necessário
  /// seja possível formatar erros de API em erros FLUTTER
  FlutterErrorDetails parseError(String message, int statusCode, String phrase) {
    return FlutterErrorDetails(
        exception: FlutterError("Client Exception.\n" +
            "Message: $message.\n" +
            "Status: $statusCode.\n" +
            "Phrase: $phrase.\n"));
  }
}
