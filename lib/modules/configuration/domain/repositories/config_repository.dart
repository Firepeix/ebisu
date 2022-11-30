import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ConfigRepositoryInterface {
  static Future<void> install(FirebaseRemoteConfig _remoteConfig) async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(minutes: 10),
    ));

    await _remoteConfig.fetchAndActivate();
  }

  Future<String> getEndpointUrl();
  Future<String> getLocalEndpoint();
  Future<void> saveEndpointUrl(String endpoint);

  Future<String> getAuthToken();
  Future<void> saveAuthToken(String token);

  Future<bool> shouldUseLocalEndpoint();
  Future<void> saveUseLocalEndpoint(bool should);
}

@Injectable(as: ConfigRepositoryInterface)
class ConfigRepository implements ConfigRepositoryInterface {
  static const ENDPOINT_CONFIG_KEY = 'EBISU_ENDPOINT';
  static const SHOULD_USE_LOCAL_ENDPOINT_KEY = 'SHOULD_USE_LOCAL_ENDPOINT';
  static const AUTH_TOKEN_CONFIG_KEY = 'AUTH_TOKEN';

  final _remoteConfig = kDebugMode ? null : FirebaseRemoteConfig.instance;

  Future<String> getLocalEndpoint() async {
    final defaultEndpoint = const String.fromEnvironment(ENDPOINT_CONFIG_KEY, defaultValue: "http://localhost");
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(ENDPOINT_CONFIG_KEY) ?? defaultEndpoint;
  }

  @override
  Future<String> getEndpointUrl() async {
    if(await shouldUseLocalEndpoint()) {
      return await getLocalEndpoint();
    }

    final endpoint = _remoteConfig?.getString(ENDPOINT_CONFIG_KEY);

    return endpoint != null && endpoint == '' ? await getLocalEndpoint() : endpoint!;
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

  @override
  Future<void> saveUseLocalEndpoint(bool should) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(SHOULD_USE_LOCAL_ENDPOINT_KEY, should);
  }

  @override
  Future<bool> shouldUseLocalEndpoint() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SHOULD_USE_LOCAL_ENDPOINT_KEY) ?? false;
  }
}