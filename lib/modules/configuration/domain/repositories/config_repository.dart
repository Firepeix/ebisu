import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef RemoteConfigDecoder<T> = T Function(String value);

enum Application {
  Ebisu(ConfigRepository.EBISU_ENDPOINT_CONFIG_KEY),
  Scout(ConfigRepository.SCOUT_ENDPOINT_CONFIG_KEY);

  final String endpointKey;

  const Application(this.endpointKey);

  String get localEndpointKey {
    return "${ConfigRepository.LOCAL_ENDPOINT_CONFIG_KEY}/$name";
  }

  String get shouldUseLocalEndpointKey {
    return "${ConfigRepository.SHOULD_USE_LOCAL_ENDPOINT_KEY}/$name";
  }
}

abstract class ConfigRepositoryInterface {
  static Future<void> install(FirebaseRemoteConfig _remoteConfig) async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(minutes: 10),
    ));

    await _remoteConfig.fetchAndActivate();
  }

  Future<String> getEndpointUrl(Application app);
  Future<String> getLocalEndpoint(Application app);
  Future<void> saveEndpointUrl(Application app, String endpoint);

  Future<String> getAuthToken();
  Future<void> saveAuthToken(String token);

  Future<bool> shouldUseLocalEndpoint(Application app);
  Future<void> saveUseLocalEndpoint(Application app, bool should);

  Future<T> getConfig<T>(String name, {T? base});
  T getRemoveConfig<T>(String name, T base, {RemoteConfigDecoder<T>? decoder});
  Future<void> setConfig<T>(String name, T value);
}

@Injectable(as: ConfigRepositoryInterface)
class ConfigRepository implements ConfigRepositoryInterface {
  static const EBISU_ENDPOINT_CONFIG_KEY = 'EBISU_ENDPOINT';
  static const SCOUT_ENDPOINT_CONFIG_KEY = 'SCOUT_ENDPOINT';
  static const LOCAL_ENDPOINT_CONFIG_KEY = 'LOCAL_ENDPOINT';
  static const SHOULD_USE_LOCAL_ENDPOINT_KEY = 'SHOULD_USE_LOCAL_ENDPOINT';
  static const AUTH_TOKEN_CONFIG_KEY = 'AUTH_TOKEN';

  final _remoteConfig = kDebugMode ? null : FirebaseRemoteConfig.instance;

  Future<String> getLocalEndpoint(Application app) async {
    final defaultEndpoint = "http://localhost";
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(app.localEndpointKey) ?? defaultEndpoint;
  }

  @override
  Future<String> getEndpointUrl(Application app) async {
    if (await shouldUseLocalEndpoint(app)) {
      return await getLocalEndpoint(app);
    }

    final endpoint = _remoteConfig?.getString(app.endpointKey);

    return endpoint != null && endpoint == '' ? await getLocalEndpoint(app) : endpoint!;
  }

  @override
  Future<void> saveEndpointUrl(Application app, String endpoint) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(app.localEndpointKey, endpoint);
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
  Future<void> saveUseLocalEndpoint(Application app, bool should) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(app.shouldUseLocalEndpointKey, should);
  }

  @override
  Future<bool> shouldUseLocalEndpoint(Application app) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(app.shouldUseLocalEndpointKey) ?? false;
  }

  @override
  Future<T> getConfig<T>(String name, {T? base}) async {
    final prefs = await SharedPreferences.getInstance();
    final varname = T.toString();

    if (varname.startsWith("bool")) {
      return (prefs.getBool(name) ?? base) as T;
    }

    if (varname.startsWith("String")) {
      return (prefs.getString(name) ?? base) as T;
    }

    return null as T;
  }

  @override
  Future<void> setConfig<T>(String name, T value) async {
    final prefs = await SharedPreferences.getInstance();
    final varname = T.toString();

    if (varname.startsWith("bool")) {
      prefs.setBool(name, value as bool);
    }

    if (varname.startsWith("String")) {
      prefs.setString(name, value as String);
    }
  }

  T getRemoveConfig<T>(String name, T base, {RemoteConfigDecoder<T>? decoder}) {
    final varname = T.toString();

    if (varname.startsWith("bool")) {
      final config = _remoteConfig?.getBool(name) ?? base;
      return config as T;
    }

    if (varname.startsWith("String")) {
      final config = _remoteConfig?.getString(name) ?? "";
      return config != "" ? config as T : base;
    }

    final config = _remoteConfig?.getString(name) ?? "";

    if (config == "") {
      return base;
    }

    return decoder == null ? base : decoder(config);
  }
}
