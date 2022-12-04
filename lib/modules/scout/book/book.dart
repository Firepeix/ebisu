import 'package:ebisu/modules/scout/book/services/service.dart';
import 'package:injectable/injectable.dart';

abstract class BookInterface {
  void init();
  void register();
}

@Injectable(as: BookInterface)
class Book implements BookInterface {
  final BookServiceInterface _service;

  Book(this._service);

  @override
  void init() => _service.init();

  @override
  void register() {
  }
}