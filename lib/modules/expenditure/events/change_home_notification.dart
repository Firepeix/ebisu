import 'package:ebisu/ui_components/chronos/layout/home_view.dart';
import 'package:flutter/material.dart';

class ChangeHomeNotification extends Notification {
  final HomeView homeView;

  ChangeHomeNotification(this.homeView);
}