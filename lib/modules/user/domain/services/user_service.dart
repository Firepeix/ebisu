import 'package:ebisu/modules/user/domain/repositories/user_repository.dart';
import 'package:ebisu/modules/user/models/user_model.dart';
import 'package:ebisu/shared/exceptions/handler.dart';
import 'package:injectable/injectable.dart';

abstract class UserServiceInterface {
  Future<List<UserModel>> getFriends();
}

@Injectable(as: UserServiceInterface)
class UserService implements UserServiceInterface {
  final UserRepositoryInterface _repository;
  final ExceptionHandlerInterface _exceptionHandler;

  UserService(this._repository, this._exceptionHandler);

  @override
  Future<List<UserModel>> getFriends() async {
    final result = await _repository.getFriends();
    return _exceptionHandler.expect(result) ?? [];
  }
}