import 'package:ebisu/modules/user/domain/mappers/user_mapper.dart';
import 'package:ebisu/modules/user/models/user_model.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/exceptions/result_error.dart';
import 'package:ebisu/shared/http/client.dart';
import 'package:injectable/injectable.dart';

class UserError extends ResultError {
  const UserError.getFriends() : super("Não foi possível buscar seus amigos", "UF1", null);
}

abstract class UserRepositoryInterface {
  Future<Result<List<UserModel>, UserError>> getFriends();
}

class _Endpoint {
  static const FriendsIndex = "users/friends";
}

@Injectable(as: UserRepositoryInterface)
class CardRepository implements UserRepositoryInterface {
  final Caron _caron;
  final UserMapper _mapper;
  CardRepository(this._caron, this._mapper);

  @override
  Future<Result<List<UserModel>, UserError>> getFriends() async {
    final result = await _caron.getList<UserModel>(_Endpoint.FriendsIndex, _mapper.fromJson);
    return result.map((value) => value.data).mapErrTo(UserError.getFriends());
  }
}