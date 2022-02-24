import 'package:ebisu/modules/scout/book/presenter.dart';
import 'package:ebisu/shared/dependency/dependency_container.dart';
import 'package:ebisu/shared/navigator/navigator_interface.dart';
import 'package:flutter/material.dart';

class BookNavigator extends NavigatorInterface {
  final BookPresenter _presenter;
  BookNavigator(this._presenter) {
    routes = {
      "/scout/books": (String name, Map<String, dynamic> arguments) =>
          init(name, arguments)
    };
  }

  Widget init(String _, Map<String, dynamic> _a) => _presenter.initWidget();

  void goToInitialRoute() =>
      DependencyManager.getNavigator()?.pushNamed(
          "/scout/books", arguments: {'navigator': this});
}