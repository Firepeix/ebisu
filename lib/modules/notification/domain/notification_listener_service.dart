import 'package:ebisu/modules/expenditure/domain/services/expense_service.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:notifications/notifications.dart';

abstract class NotificationListenerService {
  void startListening();
}

abstract class ListenNotification {
  String name();
  void listen(NotificationEvent event);
}

@Singleton(as: NotificationListenerService)
class NotificationListener implements NotificationListenerService {
  Notifications? _notifications;
  Map<String, StreamSubscription<NotificationEvent>?> _subscriptions = {};
  bool started = false;

  void startListening() {
    _notifications = Notifications();
    _registerServices();
    started = true;
  }

  void _register(ListenNotification listener) {
    _subscriptions[listener.name()] = _notifications?.notificationStream?.listen(listener.listen);
  }

  void _registerServices() {
    final services = [ExpenseServiceInterface.registerListenerForNotification()];
    services.forEach((element) => _register(element));
  }

  void stopListening(String listenerName) {
    _subscriptions[listenerName]?.cancel();
  }
}
