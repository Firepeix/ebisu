import 'package:ebisu/modules/configuration/domain/services/cache_service.dart';
import 'package:ebisu/modules/user/domain/mappers/user_mapper.dart';
import 'package:ebisu/modules/user/models/user_model.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/exceptions/result_error.dart';
import 'package:ebisu/shared/http/client.dart';
import 'package:ebisu/shared/http/response.dart';
import 'package:injectable/injectable.dart';

abstract class UserRepositoryInterface {

  static const FRIENDS_CACHE_KEY = "FRIENDS_CACHE";

  Future<Result<List<UserModel>, ResultError>> getFriends();
}

class _Endpoint {
  static const FriendsIndex = "users/friends";
}

@Injectable(as: UserRepositoryInterface)
class CardRepository implements UserRepositoryInterface {
  final Caron _caron;
  final UserMapper _mapper;
  final CacheServiceInterface _cacheService;

  CardRepository(this._caron, this._mapper, this._cacheService);

  @override
  Future<Result<List<UserModel>, ResultError>> getFriends() async {
    
    final friends = await _getFriendsFromCache();
    if (friends != null) {
      return Ok(friends);
    }

    final result = await _caron.getList<UserModel>(_Endpoint.FriendsIndex, _mapper.fromJson);

    result.willLet(ok: _saveFriendsInCache);

    return result.map((value) => value.data).message("Não foi possível buscar seus amigos");
  }

  Future<List<UserModel>?> _getFriendsFromCache() async {
    return await _cacheService.getItem(UserRepositoryInterface.FRIENDS_CACHE_KEY, _mapper.fromJsonList);
  }

  Future<void> _saveFriendsInCache(ListResponse<UserModel> result) async {
    return await _cacheService.setItem(UserRepositoryInterface.FRIENDS_CACHE_KEY, result.map(_mapper.toJson).toJson());
  }
}
