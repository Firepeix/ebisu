import 'dart:convert';

import 'package:ebisu/modules/card/domain/repositories/card_repository.dart';
import 'package:ebisu/modules/establishment/domain/repositories/establishment_repository.dart';
import 'package:ebisu/modules/user/domain/repositories/user_repository.dart';
import 'package:ebisu/shared/utils/scope.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';


typedef RemoteMapper<T> = T Function(Map<String, dynamic>  value);

abstract class CacheServiceInterface {
  Future<T?> getItem<T>(String key, RemoteMapper<T> mapper, {T? base});
  Future<void> setItem<T>(String key, T value);
  Future<void> clearItem(String key);
  Future<void> clear();
}

@Injectable(as: CacheServiceInterface)
class CacheService implements CacheServiceInterface {

  @override
  Future<T?> getItem<T>(String key, RemoteMapper<T> mapper, {T? base}) async {
    final prefs = await SharedPreferences.getInstance();
    return scope(prefs.getString(key))?.run((item) => mapper(jsonDecode(item))) ?? base;
  }

  @override
  Future<void> setItem<T>(String key, T value) async {
    final prefs = await SharedPreferences.getInstance();
     prefs.setString(key, jsonEncode(value));
  }

  @override
  Future<void> clearItem(String key) async {
    final prefs = await SharedPreferences.getInstance();
     prefs.remove(key);
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(UserRepositoryInterface.FRIENDS_CACHE_KEY);
    prefs.remove(CardRepositoryInterface.CARD_CACHE_KEY);
    prefs.remove(EstablishmentRepositoryInterface.ESTABLISHMENT_CACHE_KEY);
  }
}
