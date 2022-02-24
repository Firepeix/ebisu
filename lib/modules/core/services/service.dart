import 'package:ebisu/modules/core/interactor.dart';
import 'package:ebisu/modules/scout/book/book.dart';
import 'package:ebisu/shared/dependency/dependency_container.dart';
import 'package:ebisu/shared/navigator/navigator_interface.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

abstract class CoreServiceInterface {
  void init();
  void initScoutBookModule();
  Widget getDrawer();
  GlobalKey<NavigatorState> navigatorKey();
}

@Injectable(as: CoreServiceInterface)
class CoreService implements CoreServiceInterface {
  late final CoreInteractor _interactor = CoreInteractor(this);
  final NavigatorService _navigator;

  CoreService(this._navigator);

  @override
  void init() => _interactor.init();

  @override
  Widget getDrawer() => _interactor.getDrawer();

  void initScoutBookModule () => DependencyManager.get<BookInterface>().init();

  @override
  GlobalKey<NavigatorState> navigatorKey() => _navigator.navigatorKey;
}