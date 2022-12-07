import 'package:ebisu/modules/expenditure/domain/services/expense_service.dart';
import 'package:injectable/injectable.dart';
import 'dart:async';
import 'package:notifications/notifications.dart' as NotificationPlugin;

class NotificationEvent {
  final String packageName;
  final String message;

  NotificationEvent(this.message, this.packageName);
}

abstract class NotificationListenerServiceInterface {
  void install();
  void uninstall();
}

abstract class ListenNotification {
  String name();
  void listen(NotificationEvent event);
}

@Singleton(as: NotificationListenerServiceInterface)
class NotificationListener implements NotificationListenerServiceInterface {
  NotificationPlugin.Notifications? _stream;
  List<ListenNotification> _listeners = [];
  StreamSubscription<NotificationPlugin.NotificationEvent>? _subscription;
  bool started = false;

  Future<void> install() async {
    if (!started) {
      _stream = NotificationPlugin.Notifications();
      _registerListeners();
      _subscription = _stream?.notificationStream?.listen((data) {
        final event = map(data);
        _listeners.forEach((listener) => listener.listen(event));
      });
      started = true;
    }
  }

  void uninstall() {}

  void _registerListeners() {
    _listeners.add(ExpenseServiceInterface.registerListenerForNotification());
  }

  NotificationEvent map(NotificationPlugin.NotificationEvent event) {
    return NotificationEvent(event.message ?? "", event.packageName ?? "");
  }
}
