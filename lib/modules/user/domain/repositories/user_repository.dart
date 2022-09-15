import 'package:ebisu/modules/user/domain/mappers/user_mapper.dart';
import 'package:ebisu/modules/user/models/user_model.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/http/client.dart';
import 'package:injectable/injectable.dart';

enum UserError implements ResultError {
  GET_FRIENDS_ERROR("Não foi possível buscar seus amigos", "UF1");

  final String message;
  final String code;
  final dynamic details;

  const UserError(this.message, this.code, { this.details });
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
    final result = await _caron.get(_Endpoint.FriendsIndex, _mapper.fromJsonList);
    return result.subError(UserError.GET_FRIENDS_ERROR);
  }
}