import 'package:ebisu/modules/layout/services/service.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

abstract class CoreInterface {
  void init();
  Widget getDrawer();
}

@Injectable(as: CoreInterface)
class Core implements CoreInterface {
  final CoreServiceInterface _service;

  Core(this._service);

  @override
  void init() {
    _service.init();
  }

  @override
  Widget getDrawer() => _service.getDrawer();
}