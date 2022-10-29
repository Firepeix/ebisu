import 'package:ebisu/main.dart';
import 'package:ebisu/shared/services/notification_service.dart';
import 'package:ebisu/ui_components/chronos/list/decorated_list_box.dart';
import 'package:flutter/material.dart';

typedef DismissedCallback = void Function(bool isDismissed);

class DismissibleTile extends StatelessWidget {
  final DecoratedTile child;
  final DismissedCallback? onDismissed;
  final bool confirmOnDismissed;
  final _notification = getIt<NotificationService>();


  DismissibleTile({required this.child, this.onDismissed, this.confirmOnDismissed = false});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(confirmOnDismissed ? "${child.id()}-${DateTime.now()}" : child.id()),
      onDismissed: (_) async {
        if (confirmOnDismissed) {
          final result = await _notification.displayConfirmation(context: context);
          onDismissed?.call(result == ConfirmResult.confirmed);
          return;
        }

        onDismissed?.call(true);
      },
      background: Container(color: Colors.red),
      child: child,
    );
  }
}