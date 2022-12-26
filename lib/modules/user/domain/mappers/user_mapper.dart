import 'package:ebisu/modules/user/models/user_model.dart';
import 'package:ebisu/shared/http/request.dart';
import 'package:injectable/injectable.dart';

@injectable
class UserMapper {
  UserModel fromJson(Json json) {
    return UserModel(json["id"], json["name"]);
  }

  Json toJson(UserModel source) {
    return {"id": source.id, "name": source.name};
  }

  List<UserModel> fromJsonList(Json json) {
    return (json["data"] as List<dynamic>).map((e) => fromJson(e)).toList();
  }
}
