import 'package:ebisu/modules/establishment/models/establishment_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class EstablishmentMapper {
  EstablishmentModel fromJson(Map<dynamic, dynamic> json) {
    return EstablishmentModel(
        json["id"],
        json["name"]
    );
  }

  List<EstablishmentModel> fromJsonList(Map<dynamic, dynamic> json) {
    return (json["data"] as List<dynamic>).map((e) => fromJson(e)).toList();
  }
}