import 'package:ebisu/modules/configuration/domain/repositories/config_repository.dart';
import 'package:ebisu/shared/exceptions/handler.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/exceptions/result_error.dart';
import 'package:ebisu/shared/http/client.dart';
import 'package:ebisu/shared/http/response.dart';
import 'package:ebisu/shared/services/notification_service.dart';
import 'package:injectable/injectable.dart';

abstract class _Endpoint {
  static const Login = "auth/login";
}
abstract class AuthServiceInterface {
  Future<Result<void, ResultError>> login(String email, String password);
}

@Injectable(as: AuthServiceInterface)
class AuthService implements AuthServiceInterface {
  final Caron _client;
  final NotificationService _notificationService;
  final ExceptionHandlerInterface _exceptionHandler;
  final ConfigRepositoryInterface _config;


  AuthService(
      this._client,
      this._notificationService,
      this._exceptionHandler,
      this._config
  );

  @override
  Future<Result<void, ResultError>> login(String email, String password) async {

    _notificationService.displayLoading();
    final result = await _client.post<TokenResponse, Map<dynamic, dynamic>>(_Endpoint.Login, { "email": email, "password": password }, (body) => body, decoder: (response) => TokenResponse(response["token"]));
    _exceptionHandler.expect(result);

    await result.willLet(ok: (value) async {
      await _config.saveAuthToken(value.token);
      _notificationService.displaySuccess(message: "Login realizado com sucesso!");
    });

    _exceptionHandler.expect(result);

    return result;
  }
}