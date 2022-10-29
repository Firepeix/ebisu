import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ConfigRepositoryInterface {
  Future<String> getEndpointUrl();
  Future<void> saveEndpointUrl(String endpoint);

  Future<String> getAuthToken();
  Future<void> saveAuthToken(String token);
}

@Injectable(as: ConfigRepositoryInterface)
class ConfigRepository implements ConfigRepositoryInterface {
  static const ENDPOINT_CONFIG_KEY = 'EBISU_ENDPOINT';
  static const AUTH_TOKEN_CONFIG_KEY = 'AUTH_TOKEN';

  @override
  Future<String> getEndpointUrl() async {
    final defaultEndpoint = const String.fromEnvironment(ENDPOINT_CONFIG_KEY, defaultValue: "http://localhost");
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(ENDPOINT_CONFIG_KEY) ?? defaultEndpoint;
  }

  @override
  Future<void> saveEndpointUrl(String endpoint) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(ENDPOINT_CONFIG_KEY, endpoint);
  }

  @override
  Future<String> getAuthToken() async {
    final token = const String.fromEnvironment(AUTH_TOKEN_CONFIG_KEY, defaultValue: "EMPTY");
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AUTH_TOKEN_CONFIG_KEY) ?? token;
  }

  @override
  Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(AUTH_TOKEN_CONFIG_KEY, token);
  }
}