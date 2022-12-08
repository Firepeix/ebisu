import 'package:ebisu/modules/expenditure/domain/services/expense_service.dart';
import 'package:injectable/injectable.dart';
import 'dart:async';
import 'package:notifications/notifications.dart' as NotificationPlugin;
//import 'package:telephony/telephony.dart';

enum NotificationEventType { Push, Sms }

onBackgroundMessage(NotificationEvent event, List<ListenNotification> listeners) {
  listeners.forEach((listener) => listener.listen(event));
}

class NotificationEvent {
  final String packageName;
  final String message;
  final NotificationEventType type;

  NotificationEvent(this.message, this.packageName, this.type);
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
  bool notificationListenerStatus = false;

  //Telephony? _telephony;
  bool telephonyStatus = false;

  List<ListenNotification> _listeners = [];

  StreamSubscription<NotificationPlugin.NotificationEvent>? _subscription;

  Future<void> install() async {
    _registerListeners();
    _installNotificationListener();
    //_instalSMSListener();
  }

  Future<void> _installNotificationListener() async {
    if (!notificationListenerStatus) {
      _stream = NotificationPlugin.Notifications();
      _subscription = _stream?.notificationStream?.listen((data) {
        final event = map(data);
        _listeners.forEach((listener) => listener.listen(event));
      });
      notificationListenerStatus = true;
    }
  }

  //Future<void> _instalSMSListener() async {
  //  if (!telephonyStatus) {
  //    _telephony = Telephony.instance;
  //    bool? result = await _telephony?.requestPhoneAndSmsPermissions;
//
  //    if (result == false) {
  //      result = await _telephony?.requestPhoneAndSmsPermissions;
  //    }
//
  //    if (result == true) {
  //      _telephony?.listenIncomingSms(
  //        listenInBackground: false,
  //          onNewMessage: (event) => onBackgroundMessage(mapSms(event), _listeners), 
  //          //onBackgroundMessage: (event) => onBackgroundMessage(mapSms(event), _listeners)
  //      );
  //    }
  //  }
  //}

  void uninstall() {}

  void _registerListeners() {
    _listeners.add(ExpenseServiceInterface.registerListenerForNotification());
  }

  NotificationEvent map(NotificationPlugin.NotificationEvent event) {
    return NotificationEvent(event.message ?? "", event.packageName ?? "", NotificationEventType.Push);
  }

  //NotificationEvent mapSms(SmsMessage event) {
  //  return NotificationEvent(event.body ?? "", event.address ?? "", NotificationEventType.Sms);
  //}
}
