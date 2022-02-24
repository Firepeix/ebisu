import 'package:ebisu/modules/core/presenter.dart';
import 'package:ebisu/modules/core/services/service.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

abstract class CoreInteractorInterface {
  void init();
  Widget getDrawer();
  void initScoutBookModule();
  GlobalKey<NavigatorState> navigatorKey();
}

@Injectable(as: CoreInteractorInterface)
class CoreInteractor implements CoreInteractorInterface {
  final CoreServiceInterface _service;

  CoreInteractor(this._service);

  final _presenter = CorePresenter();

  @override
  void init() => _presenter.init();

  @override
  Widget getDrawer() => _presenter.drawer();

  @override
  void initScoutBookModule() => _service.initScoutBookModule();

  @override
  GlobalKey<NavigatorState> navigatorKey() => _service.navigatorKey();
}