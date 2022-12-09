import 'package:ebisu/modules/configuration/domain/repositories/config_repository.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'dart:async';

abstract class BackgroundServiceInterface {
  static const BACKGROUND_PLUGIN_CHANNEL = "ebisu.firepeix.com/background_plugin";
  static const BACKGROUND_PLUGIN_STREAM = "ebisu.firepeix.com/background_plugin/stream";
  static const BACKGROUND_IS_RUNNING_KEY = "BACKGROUND_IS_RUNNING";
  Future<void> install();
  Future<void> uninstall();
  Future<bool> isRunning();
}

@Singleton(as: BackgroundServiceInterface)
class BackgroundService implements BackgroundServiceInterface {
  final ConfigRepositoryInterface _config;

  BackgroundService(this._config);

  final batteryEventChannel = const EventChannel(BackgroundServiceInterface.BACKGROUND_PLUGIN_STREAM);
  final _batteryPlatformChannel = const MethodChannel(BackgroundServiceInterface.BACKGROUND_PLUGIN_CHANNEL);

  @override
  Future<void> install() async {
    _config.setConfig(BackgroundServiceInterface.BACKGROUND_IS_RUNNING_KEY, true);
    await _batteryPlatformChannel.invokeMethod('BackgroundPlugin.installService');
  }

  Future<void> uninstall() async {
    _config.setConfig(BackgroundServiceInterface.BACKGROUND_IS_RUNNING_KEY, false);
    try {
      await _batteryPlatformChannel.invokeMethod('BackgroundPlugin.uninstallService');
    } catch (error) {
      print(error);
    }
  }

  @override
  Future<bool> isRunning() async {
    return await _config.getConfig(BackgroundServiceInterface.BACKGROUND_IS_RUNNING_KEY, base: false);
  }
}
