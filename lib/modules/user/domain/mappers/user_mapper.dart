import 'package:ebisu/modules/user/models/user_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class UserMapper {
  UserModel fromJson(Map<dynamic, dynamic> json) {
    return UserModel(
        json["id"],
        json["name"]
    );
  }

  List<UserModel> fromJsonList(Map<dynamic, dynamic> json) {
    return (json["data"] as List<dynamic>).map((e) => fromJson(e)).toList();
  }
}