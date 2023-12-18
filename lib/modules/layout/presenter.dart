import 'package:ebisu/modules/layout/components/drawer.dart';
import 'package:ebisu/modules/layout/navigator.dart';
import 'package:flutter/material.dart';

class CorePresenter {
  late final _navigator = CoreNavigator(this);

  void init() {
    _navigator.goToInitialRoute();
  }

  Widget initWidget() => Container();

  Widget drawer() => EbisuDrawer();
}