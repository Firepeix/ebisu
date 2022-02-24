import 'package:ebisu/shared/navigator/navigator_interface.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class DependencyManager {
  static T get<T extends Object>() {
    return getIt<T>();
  }

  static NavigatorState? getNavigator() {
    return getIt<NavigatorService>().navigatorKey.currentState;
  }
}