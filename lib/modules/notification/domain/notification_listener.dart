import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';

class NotificationEvent {
  String? packageName;

  String? title;

  String? message;

  DateTime? timeStamp;

  NotificationEvent({
    this.packageName,
    this.title,
    this.message,
    this.timeStamp,
  });

  factory NotificationEvent.fromMap(Map<dynamic, dynamic> map) {
    DateTime time = DateTime.now();
    String? name = map['packageName'];
    String? message = map['message'];
    String? title = map['title'];

    return NotificationEvent(
      packageName: name,
      title: title,
      message: message,
      timeStamp: time,
    );
  }

  @override
  String toString() => '$runtimeType - package: $packageName, title: $title, message: $message, timestamp: $timeStamp';
}

NotificationEvent _notificationEvent(dynamic data) {
  return new NotificationEvent.fromMap(data);
}


class NotificationListener {
  static const EventChannel _notificationEventChannel = EventChannel('ebisu.firepeix.com/notifications_plugin');

  Stream<NotificationEvent>? _notificationStream;

  Stream<NotificationEvent>? get notificationStream {
    if (Platform.isAndroid) {
      if (_notificationStream == null) {
        _notificationStream = _notificationEventChannel
            .receiveBroadcastStream()
            .map((event) => _notificationEvent(event));
      }
      return _notificationStream;
    }
    throw NotificationException('Notification API exclusively available on Android!');
  }
}

/// Custom Exception for the plugin.
/// Thrown whenever the plugin is used on platforms other than Android.
class NotificationException implements Exception {
  String message;

  NotificationException(this.message);

  @override
  String toString() => '$runtimeType - $message';
}