import 'package:ebisu/modules/core/presenter.dart';
import 'package:ebisu/shared/dependency/dependency_container.dart';
import 'package:ebisu/shared/navigator/navigator_interface.dart';
import 'package:flutter/material.dart';

class CoreNavigator extends NavigatorInterface {
  final CorePresenter _presenter;

  CoreNavigator(this._presenter) {
    routes = {
      "/template": (String name, Map<String, dynamic> arguments) =>
          init(name, arguments)
    };
  }

  Widget init(String _, Map<String, dynamic> _a) => _presenter.initWidget();

  void goToInitialRoute() =>
      DependencyManager.getNavigator()?.pushNamed(
          "/template", arguments: {'navigator': this});
}