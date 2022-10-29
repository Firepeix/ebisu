import 'package:flutter/material.dart';

class ChangeMainButtonActionNotification extends Notification {
  final VoidCallback? onPressed;

  ChangeMainButtonActionNotification(this.onPressed);
}