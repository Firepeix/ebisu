import 'package:ebisu/modules/establishment/models/establishment_model.dart';
import 'package:ebisu/shared/http/request.dart';
import 'package:injectable/injectable.dart';

@injectable
class EstablishmentMapper {
  EstablishmentModel fromJson(Map<String, dynamic> json) {
    return EstablishmentModel(json["id"], json["name"]);
  }

  Json toJson(EstablishmentModel source) {
    return {"id": source.id, "name": source.name};
  }

  List<EstablishmentModel> fromJsonList(Map<String, dynamic> json) {
    return (json["data"] as List<dynamic>).map((e) => fromJson(e)).toList();
  }
}
